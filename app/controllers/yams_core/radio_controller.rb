# frozen_string_literal: true

module YamsCore
  class RadioController < ApplicationController

    include YamsCore::FetchTracks

    helper  YamsAudio::PlayerHelper

    def show
      # Settings for rendering the Audio Player
      @yams_player_settings = YamsAudio::PlayerSettingsBuilder.call(user: current_user, auto_play: false)

      @track = YamsAudio::TrackPresenter.new(view_context: view_context)
    end

    private

    def populate_tracks
      @tracks = to_presenters(random_free_tracks)
    end

  end
end
