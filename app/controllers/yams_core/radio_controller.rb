# frozen_string_literal: true

module YamsCore
  class RadioController < ApplicationController

    include YamsCore::FetchTracks

    helper  DatashiftAudioEngine::PlayerHelper

    def create
      populate_tracks

      # HTML or JS is to Render the Audio Player, a JSON format is to Render the Playlist and actual audio data
      @datashift_audio_json = AudioEngineJsonBuilder.call(@tracks, current_user)
      #pp JSON.parse(@datashift_audio_json)
    end

    def show
      populate_tracks

      # HTML or JS is to Render the Audio Player, a JSON format is to Render the Playlist and actual audio data
      @datashift_audio_json = AudioEngineJsonBuilder.call(@tracks, current_user)
      #pp JSON.parse(@datashift_audio_json)
      #
      render :create
    end

    private

    def populate_tracks
      @tracks = to_presenters(random_free_tracks)
    end

  end
end
