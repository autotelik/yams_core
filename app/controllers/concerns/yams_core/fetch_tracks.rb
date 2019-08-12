# frozen_string_literal: true

module YamsCore
  module FetchTracks
    extend ActiveSupport::Concern

    def random_tracks

      # Technique to generate same list for a certain time - driven by the cookie expire time
      # seed_val = Track.connection.quote(cookies[:rand_seed])
      seed_val = rand
      Track.connection.execute("select setseed(#{seed_val})")

      Track.eager_load(:user)
          .includes([{ audio_attachment: :blob }, { cover: { image_attachment: :blob } }, :taggings])
          .order('random()')
          .page(params[:page])
          .per(per_page)
    end

    def random_free_tracks
      random_tracks.for_free
    end

    def to_presenters(tracks)
      tracks.collect { |t| TrackPresenter.new(t, view_context) }
    end

    def per_page
      params[:per_page] || 30
    end

  end
end
