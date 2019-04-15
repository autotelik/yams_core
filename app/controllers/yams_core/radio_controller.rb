# frozen_string_literal: true

module YamsCore
  class RadioController < ApplicationController

    helper  DatashiftAudioEngine::PlayerHelper

    def create

      per_page = params[:per_page] || 30

      # Technique to generate same list for a certain time - driven by the cookie expire time
      # seed_val = Track.connection.quote(cookies[:rand_seed])
      seed_val = rand
      Track.connection.execute("select setseed(#{seed_val})")

      @tracks = Track.eager_load(:user)
                  .includes([{ audio_attachment: :blob }, { cover: { image_attachment: :blob } } ])
                  .for_free.order('random()')
                  .page(params[:page]).per(per_page)

      # HTML or JS is to Render the Audio Player, a JSON format is to Render the Playlist and actual audio data
      @datashift_audio_json = AudioEngineJsonBuilder.call(@tracks, current_user)
      #pp JSON.parse(@datashift_audio_json)
    end

  end
end
