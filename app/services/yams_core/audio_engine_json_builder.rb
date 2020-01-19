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
      puts "Oh FFS", DatashiftAudioEngine::Config.call.wave_color, DatashiftAudioEngine::Config.call.progress_color ,DatashiftAudioEngine::Config.call.cursor_color

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
            json.wave_color     '#f7931a'
            json.progress_color '#c7630a'
            json.cursor_color   '#010101'
          end

          json.playlist do
            json.tracks    YamsCore::AudioEnginePlayListBuilder.call(tracks, current_user)
            json.track_idx '0'
            json.position  '0'
          end

          # TODO: how is pagination gonna work ?
          json.pagination do
            json.page '0'
            json.total_pages 1
          end

        end
      end
    end

  end

  private

  attr_reader :current_user, :tracks
end
