# frozen_string_literal: true

module YamsCore
  class RadioController < ApplicationController

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

    def per_page
        params[:per_page] || 30
    end

    def populate_tracks

      # Technique to generate same list for a certain time - driven by the cookie expire time
      # seed_val = Track.connection.quote(cookies[:rand_seed])
      seed_val = rand
      Track.connection.execute("select setseed(#{seed_val})")

      tracks = Track.eager_load(:user)
                    .includes([{ audio_attachment: :blob }, { cover: { image_attachment: :blob } }, :taggings])
                    .for_free.order('random()')
                    .page(params[:page]).per(per_page)

      @tracks = tracks.collect { |t| TrackPresenter.new(t, view_context) }
    end

  end
end
