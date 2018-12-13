# frozen_string_literal: true
module YamsCore
  class ArtistPresenter < YamsCore::Presenter

    def initialize(artist, view)
      super(artist, view)
    end

    alias_method :artist, :model

  end
end
