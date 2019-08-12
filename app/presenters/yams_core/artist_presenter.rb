# frozen_string_literal: true
module YamsCore
  class ArtistPresenter < YamsCore::Presenter

    def initialize(artist, view)
      super(artist, view)
    end

    alias_method :artist, :model

    def avatar_image(size: :thumb)
      @avatar_image ||= if self.avatar.try(:attached?)
                          avatar
                        else
                          DefaultCover.for_artist.image
                        end
    end

  end
end
