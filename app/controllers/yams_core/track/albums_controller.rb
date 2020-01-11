# frozen_string_literal: true

module YamsCore

  class Track::AlbumsController < ApplicationController

    before_action :authenticate_user!

    # TODO candidate for concern - mimics app/controllers/yams_core/album/tracks_controller.rb but has different rendering requirements
    def create

      @album = Album.find(album_track_params[:album_id])

      track = Track.find(album_track_params[:id])

      @album_track = AlbumTrack.new(album: @album, track: track)

      @track = TrackPresenter.new(track, view_context)

      respond_to do |format|
        if @album_track.save
          format.html { redirect_to @track, notice: 'Track successfully added to Album' }
          format.js   { flash.now[:notice] = 'Track successfully added to Album' }
        else
          format.html { render :new }
          format.json { render json: @album_track.errors, status: :unprocessable_entity }
          format.js   { flash.now[:error] = @album_track.errors.full_messages }
        end
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_track_params
      params.require(:album_track).permit(:id, :album_id)
    end

  end
end
