# frozen_string_literal: true

module YamsCore

  class AudioEngineJsonBuilder

    include YamsCore::Services

    attr_reader :tracks, :current_user

    def initialize(tracks, current_user)
      @tracks = *tracks
      @current_user = current_user
    end

    def call
      Jbuilder.encode do |json|
        json.datashift_audio do

          json.service do
            if current_user     #  Soem streamms such as Radio stream can be accessed by non signed in visitors
              json.user_token   current_user.id
              json.client_token '0987654321' # TODO: - add tokens to devise
            end
          end

          json.settings do
            json.autoplay true
          end

          json.waveform do
            json.wave_color DatashiftAudioEngine::Config.call.wave_color
            json.progress_color DatashiftAudioEngine::Config.call.progress_color
            json.cursor_color DatashiftAudioEngine::Config.call.cursor_color
            json.bar_width 'w-100'
          end

          json.tracks YamsCore::AudioEnginePlayListBuilder.call(tracks, current_user)

          json.playlist '0'
          json.page '0'
          json.total_pages (tracks.count.to_f / 30).ceil
          json.track '0'
          json.position '0'
        end
      end
    end

  end

  private

  attr_reader :current_user, :tracks
end
