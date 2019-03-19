# frozen_string_literal: true

module YamsCore

  # TODO - think this is more or less same as album -> TrackController - stick to a naming convention and look at possible concern
  #
  class Playlist::TracksController < ApplicationController

    before_action :authenticate_user!

    def create
      playlist = Playlist.find(playlist_track_params[:id])

      track = Track.find(playlist_track_params[:track_id])

      @playlist_track = PlaylistTrack.new(playlist: playlist, track: track)

      @track = TrackPresenter.new(track, view_context)

      respond_to do |format|
        if @playlist_track.save
          format.html { redirect_to @playlist, notice: 'Track successfully added to Playlist' }
          format.js   {}
        else
          format.html { render :new }
          format.json { render json: @playlist_track.errors, status: :unprocessable_entity }
          format.js   { flash.now[:error] = @playlist_track.errors.full_messages }
        end
      end
    end

    def destroy
      playlist_track = PlaylistTrack.find(params[:id])

      # Re-enable Track for selection
      @track_presenter =  TrackPresenter.new(playlist_track.track, view_context)

      @track_row_id = @track_presenter.sortable_id

      unless playlist_track.destroy
        flash[:error] = 'Sorry we failed to remove Track from Playlist'
        redirect_back(fallback_location: root_path)
      end
    end

    private

    def playlist_track_params
      params.require(:playlist_track).permit(:id, :track_id)
    end

  end
end
