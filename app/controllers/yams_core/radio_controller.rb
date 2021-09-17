# frozen_string_literal: true

module YamsCore
  class RadioController < ApplicationController

    helper  YamsAudio::PlayerHelper

    def show
      @track = YamsAudio::TrackPresenter.new(view: view_context)
    end

  end
end
