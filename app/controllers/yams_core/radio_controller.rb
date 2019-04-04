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
      @datashift_audio_json = datashift_audio_player_setup(@tracks, current_user)
    end

    private

    def datashift_audio_player_setup(tracks, user)
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

          json.tracks YamsCore::AudioEnginePlayListBuilder.call(tracks, user)

          json.playlist '0'
          json.page '0'
          json.total_pages (tracks.count.to_f / 30).ceil
          json.track '0'
          json.position '0'
        end
      end
    end

  end
end
