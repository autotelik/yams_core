# frozen_string_literal: true

module YamsCore
  class Album < ApplicationRecord

    belongs_to :user

    has_many :album_tracks, class_name: 'AlbumTrack', dependent: :destroy
    has_many :tracks, through: :album_tracks, class_name: 'Track'

    has_one :cover, as: :owner, dependent: :destroy
    accepts_nested_attributes_for :cover, allow_destroy: true

    # TODO extract to a concern with Track, Playlist etc as contract_state : %i[draft private published etc]
    enum published_state: %i[draft published]

    acts_as_taggable

    validates_presence_of :title

    validates :title, uniqueness: { scope: :user }

    scope :for_user, -> (user) { Album.where('user_id = ?', user.id) }

    scope :without_track, -> (track, user) { Album.for_user(user).where.not(id: AlbumTrack.where('track_id = ?', track.id).select(:album_id)) }
   
    scope :with_tracks, -> { joins(:tracks) }

    include YamsCore::AvailableFor

    searchkick callbacks: :queue

    def attach_cover(file_name)
      update(cover: Cover.create!(owner: self, image: File.open(file_name)))
    end

    def tracks_for_player
      tracks.includes([:user, { audio_attachment: :blob }, { cover: { image_attachment: :blob } }, :taggings])
    end

    def name
      self.title
    end
    
=begin
  private

  def after_save_hook

    begin
      Rails.logger.debug("Calling Searchkick to update ES Album Index")
      Searchkick::ProcessQueueJob.perform_later(class_name: "Album")
    rescue Redis::CannotConnectError => x
      Rails.logger.error("Redis DOWN - Elastic search update failed #{x.message}")
    rescue  => x
      Rails.logger.error("UNHANDLED - Elastic search update failed #{x.message}")
    end

  end
=end
  end
end
