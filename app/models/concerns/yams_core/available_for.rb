# frozen_string_literal: true

module YamsCore
  module AvailableFor
    extend ActiveSupport::Concern

    included do
      has_many :availables, as: :type, dependent: :destroy, inverse_of: :type

      accepts_nested_attributes_for :availables, allow_destroy: true

      scope :for_free, -> { joins(:availables).where('availables.mode': YamsCore::Available.concepts[:free]) }
      scope :for_commercial, -> { joins(:availables).where('availables.mode': YamsCore::Available.concepts[:commercial]) }
    end

    def available_for?(mode)
      # https://semaphoreci.com/blog/2017/03/14/faster-rails-how-to-check-if-a-record-exists.html
      availables.where(type: self, mode: YamsCore::Available.concepts[mode]).exists?
    end

    # Make the inclusign model availble for supplied mode. Saves model first if required for has_many association
    def make_available_for(mode)
      save! if new_record?
      availables.create!(mode: YamsCore::Available.concepts[mode])
    end

  end
end
