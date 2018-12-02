# frozen_string_literal: true

module YamsCore

  class AudioEnginePlayListBuilder

    include Rails.application.routes.url_helpers

    include YamsCore::Services

    def initialize(tracks, current_user)
      @tracks = *tracks
      @current_user = current_user
      @per_page = 30
    end

    def call
      @tracks.collect { |track| package(track) }
    end

    def package(track)
      return {} unless track.present?

      {
        id: track.id,
        author: track.artist,
        name: track.title,
        audio_url: rails_blob_path(track.audio, only_path: true),
        cover_image: rails_blob_path(track.cover_image, only_path: true),
        duration: track.duration
      }

    end

    private

    attr_reader :current_user, :per_page, :tracks
  end
end