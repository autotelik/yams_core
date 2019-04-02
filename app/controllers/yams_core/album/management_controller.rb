# frozen_string_literal: true

module YamsCore
  class Album::ManagementController < ApplicationController

    before_action :authenticate_user!

    def index
      @albums = Album.includes(cover: { image_attachment: :blob }).for_user(current_user)
      @tracks = Track.includes(cover: { image_attachment: :blob }).for_user(current_user)
    end

  end
end
