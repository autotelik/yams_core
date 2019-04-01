# frozen_string_literal: true

module YamsCore
  class AudioPlayerInitController < ApplicationController

    helper  DatashiftAudioEngine::PlayerHelper

    def create
      # The audio player init call back -  it sends request during datashift_audio_engine.init() function call once
      # when we need to sync basic player settings possible
      # We sends back variables like {user_token} and {client_token}
      # TODO: Not sure we really need this, can't the init call to radio render this stuff and save us this ajax call
    end

  end
end
