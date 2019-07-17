# frozen_string_literal: true

module YamsCore
  class Album::ManagementController < ApplicationController

    before_action :authenticate_user!

    def index
      @albums = Album.for_user(current_user).includes([cover: { image_attachment: :blob }, album_tracks: { track: { cover: { image_attachment: :blob }} }])
      @tracks = Track.for_user(current_user).includes([cover: { image_attachment: :blob }])
    end

  end
end
