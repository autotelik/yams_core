# frozen_string_literal: true

module YamsCore
  class RadioController < ApplicationController

    helper DatashiftAudioEngine::ApplicationHelper

    layout 'application_with_player'

    def index

      respond_to do |format|

        # Render the Audio Player via HTML first
        format.html {}

        # Player partial will then make a callback to get the JSON Playlist
        format.json do
          per_page = 30

          # Technique to generate same list for a certain time - driven by the cookie expire time
          # seed_val = Track.connection.quote(cookies[:rand_seed])
          seed_val = rand
          Track.connection.execute("select setseed(#{seed_val})")

          @tracks = Track.eager_load(:cover, :user).for_free.order('random()').page(params[:page]).per(per_page)

          @tracks_json = YamsCore::AudioEnginePlayListBuilder.call(@tracks, current_user)
        end
      end
    end

  end
end