# frozen_string_literal: true
module YamsCore

  class TrackController < ApplicationController

    helper  YamsAudio::PlayerHelper
    
    def show
      @track = YamsAudio::TrackPresenter.new(view: view_context, track: YamsCore::Track.for_free.find(params[:id]))

      @list_item_id = params[:list_item_id]

      respond_to do |format|
        format.turbo_stream
        format.html { render :show }

        format.json { 
          render json: { partial: render_to_string(:show, formats: :html, layout: false) }
        }
      end
    end

  end
end
