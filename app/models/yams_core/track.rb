# frozen_string_literal: true
require 'open-uri'

module YamsCore
  class Track < ApplicationRecord
    belongs_to :user
    belongs_to :license, required: false # TODO
    belongs_to :id3_genre, required: false # TODO

    has_one :cover, as: :owner, dependent: :destroy
    accepts_nested_attributes_for :cover, allow_destroy: true

    has_many :album_tracks, class_name: 'AlbumTrack', dependent: :destroy
    has_many :albums, through: :album_tracks, class_name: 'Album'

    has_one_attached :audio

    include YamsCore::AvailableFor

    acts_as_taggable

    searchkick callbacks: :queue

    after_create :assign_mp3_properties

    after_save :after_save_hook

    validates_presence_of :title, :audio, :user

    validates :audio, attached: true, content_type: YamsCore::AudioService.valid_types


    # Tracks not in any Album
    scope :no_album, -> { includes(:albums).where(albums: { id: nil }) }

    # Tracks not in the supplied album belonging to user
    scope :without_album, -> (album, user) { Track.for_user(user).where.not(id: AlbumTrack.where('album_id = ?', album.id).select(:track_id)) }

    scope :for_user, -> (user) { Track.where('user_id = ?', user.id) }

    # TODO: probably not scalable & should spin off a job, so perhaps best driven externally, out of here completely
    def attach_audio_file(path)
      AttachAudioService.call(self, path)
    end

    def attach_cover(path)
      self.save if new_record?
      AttachCoverService.call(self, path)
    end

    def cover_image(size: :thumb)
      Rails.logger.info("DEPRECATED Track.cover_image - USE PRESENTER")
      track_cover = self.cover.try(:attached?) ? cover : DefaultCover.for_track
      track_cover.image
    end

    def artist_name
      user.try(:name)
    end

    def artist
      user
    end

    def download?
      available_for?(:download)
    end

    def duration
      length || 0
    end

    def display_duration
      Time.at(duration).utc.strftime('%M:%S')
    end

    private

    def search_data
      {
          title: title
      }
    end

    def assign_mp3_properties

      begin
        Rails.logger.debug("Calling Mp3Worker for Track #{self.id}")
        YamsCore::Mp3Worker.perform_async(self.id)
      rescue Redis::CannotConnectError => x
        Rails.logger.error("Redis DOWN - MP3 properties not updated #{x.message}")

      rescue  => x
        Rails.logger.error("UNHANDLED - MP3 properties not updated #{x.message}")
      end

    end

    def after_save_hook
      begin
        Searchkick::ProcessQueueJob.perform_later(class_name: "YamsCore::Track")
      rescue Redis::CannotConnectError => x
        Rails.logger.error("Redis DOWN - Elastic search update failed #{x.message}")
      rescue  => x
        Rails.logger.error("UNHANDLED - Elastic search update failed #{x.message}")
      end
    end

  end
end
