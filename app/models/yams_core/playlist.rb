# frozen_string_literal: true

module YamsCore
  class Playlist < ApplicationRecord

    belongs_to :user

    has_many :playlist_tracks, -> { order([:sort]) }, class_name: 'PlaylistTrack', dependent: :destroy
    has_many :tracks, through: :playlist_tracks, class_name: 'Track'

    validates_presence_of :name

    validates :name, uniqueness: { scope: :user }

    scope :for_user, -> (user) { Playlist.eager_load(:user, playlist_tracks: [:track] ).where('playlists.user_id = ?', user.id) }

    include YamsCore::AvailableFor

    acts_as_taggable

    searchkick callbacks: :queue

    def tracks_for_player
      tracks.includes([:user, { audio_attachment: :blob }, { cover: { image_attachment: :blob } }, :taggings])
    end

    private

  end
end
