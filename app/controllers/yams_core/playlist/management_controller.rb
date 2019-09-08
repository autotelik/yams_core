# frozen_string_literal: true

module YamsCore
  class Playlist::ManagementController < ApplicationController

    before_action :authenticate_user!

    def index
      @playlists = Playlist.for_user(current_user)

      @tracks = Track.includes(cover: { image_attachment: :blob } ).for_user(current_user).order(:title).page(params[:page]).per(30)
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:title, :description, :published_state, :user_id, tag_list: [], cover_attributes: %i[id image])
    end
  end
end
