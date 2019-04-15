# frozen_string_literal: true
module YamsCore
  class ArtistPresenter < YamsCore::Presenter

    def initialize(artist, view)
      super(artist, view)
    end

    alias_method :artist, :model

    def avatar_image(size: :thumb)
      @avatar ||= self.avatar.try(:attached?) ? avatar : DefaultCover.for_artist
      @avatar.image
    end

  end
end
