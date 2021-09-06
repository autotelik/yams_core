# frozen_string_literal: true

module YamsCore
  class RadioTracksController < ApplicationController

    include YamsCore::FetchTracks

    helper YamsAudio::PlayerHelper

    def index
      @pagy, @tracks = pagy(random_free_tracks)
    end

    def show
      @track = YamsAudio::TrackPresenter.new(view_context: view_context, track: YamsCore::Track.for_free.find(params[:id]))

      respond_to do |format|
        format.turbo_stream
        format.html { render :show }

        format.json { 
          render json: { partial: render_to_string(:show, formats: :html, layout: false) }
        }
      end
    end

    private

    def populate_tracks
      @tracks = to_presenters(random_free_tracks)
    end

  end
end
