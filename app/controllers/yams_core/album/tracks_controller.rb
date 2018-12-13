# frozen_string_literal: true
module YamsCore
  class Album::TracksController < ApplicationController

    before_action :authenticate_user!

    before_action :set_album, only: %i[create]

    def create
      track = Track.find(album_track_params[:track_id])

      @album_track = AlbumTrack.new(album: @album, track: track)

      @track = TrackPresenter.new(track, view_context)

      respond_to do |format|
        if @album_track.save
          format.html { redirect_to @album, notice: 'Track successfully added to Album' }
          format.js   {}
        else
          format.html { render :new }
          format.json { render json: @album_track.errors, status: :unprocessable_entity }
          format.js   { flash.now[:error] = @album_track.errors.full_messages }
        end
      end
    end

    def destroy
      album_track = AlbumTrack.find(params[:id])

      # Re-enable Track for selection
      @track_presenter =  TrackPresenter.new(album_track.track, view_context)

      @track_row_id = @track_presenter.sortable_id

      unless album_track.destroy
        flash[:error] = 'Sorry we failed to remove Track from Album'
        redirect_back(fallback_location: root_path)
      end
    end

    private

    def set_album
      @album = Album.find(album_track_params[:id])
    end

    def album_track_params
      params.require(:album_track).permit(:id, :track_id)
    end

  end
end