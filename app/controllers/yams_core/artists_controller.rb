# frozen_string_literal: true

module YamsCore

  class ArtistsController < ApplicationController

    before_action :set_artist, only: %i[show]

    before_action :authenticate_user!

    helper DatashiftAudioEngine::PlayerHelper

    layout 'application_with_player', only: %i[show]

    def show;
      respond_to do |format|
        format.html {}
        format.json do
          @tracks = @artist.tracks

          @tracks_json = YamsCore::AudioEnginePlayListBuilder.call(@tracks, current_user)
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = YamsCore::User.find(params[:id])
    end

  end


end
