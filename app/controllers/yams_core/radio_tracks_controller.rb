# frozen_string_literal: true

module YamsCore
  class RadioTracksController < ApplicationController

    include YamsCore::FetchTracks

    helper YamsAudio::PlayerHelper

    def index

      # TODO - how to generate a random selection but then paginate it and load it over multiple lazy load calls ?
      # @pagy, @tracks = pagy(random_free_tracks)

      @pagy, tracks = pagy(YamsCore::Track.eager_load(:user, :availables)
          .includes([{ audio_attachment: :blob }, { cover: { image_attachment: :blob } }, :taggings])
          .for_free)

      @tracks = tracks.collect { |t| YamsAudio::TrackPresenter.new(track: t, view: view_context) }

    end

  end
end
