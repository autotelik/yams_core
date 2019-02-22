# frozen_string_literal: true

module YamsCore
  class Album::ManagementController < ApplicationController

    before_action :authenticate_user!

    def index
      @albums = Album.for_user(current_user)
      @tracks = Track.for_user(current_user).page(params[:page]).per(30)
    end

  end
end
