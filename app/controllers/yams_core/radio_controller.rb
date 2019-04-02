# frozen_string_literal: true

module YamsCore
  class RadioController < ApplicationController

    helper  DatashiftAudioEngine::PlayerHelper
    layout 'application_with_player'

    def index

      # HTML or JS is to Render the Audio Player, a JSON format is to Render the Playlist and actual audio data
      @datashift_audio_json_settings = datashift_audio_settings if request.format.html? || request.format.js?

      respond_to do |format|

        # Render the Audio Player
        format.html {}
        format.js {}

        # Player partial will then make a callback to get the JSON Playlist
        format.json do
          per_page = 30

          # Technique to generate same list for a certain time - driven by the cookie expire time
          # seed_val = Track.connection.quote(cookies[:rand_seed])
          seed_val = rand
          Track.connection.execute("select setseed(#{seed_val})")

          @tracks = Track.eager_load(:user)
                        .includes([{ cover: { image_attachment: :blob } } ])
                        .for_free.order('random()')
                        .page(params[:page]).per(per_page)
        end
      end
    end

    private

    def datashift_audio_settings
      Jbuilder.encode do |json|
        json.datashift_audio do

          json.service do
            if current_user     # radio stream can be accessed by non signed in visitors
              json.user_token   current_user.id
              json.client_token '0987654321' # TODO: - add tokens to devise
            end
          end

          json.settings do
            json.autoplay true
          end

          json.waveform do
            json.wave_color 'white'
            json.progress_color 'blue'
            json.cursor_color 'purple'
            json.bar_width 'w-100'
          end
        end
      end
    end

  end
end
