# frozen_string_literal: true

module YamsCore

  class ArtistsController < ApplicationController

    include YamsCore::FetchTracks

    before_action :set_artist, only: %i[show]

    before_action :authenticate_user!

    helper YamsAudio::PlayerHelper

    def show;
      respond_to do |format|
        format.html do
          @tracks = to_presenters(@artist.tracks.includes([{ audio_attachment: :blob }, { cover: { image_attachment: :blob } }, :taggings]))

          # HTML or JS is to Render the Audio Player, a JSON format is to Render the Playlist and actual audio data
          @yams_audio_json = AudioEngineJsonBuilder.call(@tracks, current_user)
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = YamsCore::ArtistPresenter.new(YamsCore::User.find(params[:id]), view_context)
    end

  end

end
