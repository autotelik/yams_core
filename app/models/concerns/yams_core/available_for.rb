# frozen_string_literal: true

module YamsCore
  module AvailableFor
    extend ActiveSupport::Concern

    included do
      has_many :availables, as: :type, dependent: :destroy, inverse_of: :type

      accepts_nested_attributes_for :availables, allow_destroy: true

      scope :for_free, -> { joins(:availables).where('availables.mode': YamsCore::Available.modes[:free]) }
      scope :for_commercial, -> { joins(:availables).where('availables.mode': YamsCore::Available.modes[:commercial]) }
    end

    # TODO - benchmark ways nof getting at the modes e.g
    # availables.map(&:mode).include?('free')
    # vs
    #  availables.pluck(:mode).include?('free')
    # vs
    # availables.where(type: self, mode: mode).exists?
    #
    def available_for?(mode)
      # https://semaphoreci.com/blog/2017/03/14/faster-rails-how-to-check-if-a-record-exists.html
      availables.where(type: self, mode: mode).exists?
    end

    # Make the including model available for supplied mode. Saves model first if required for has_many association
    def make_available_for(mode, meta_data: {})
      save! if new_record?
      return if availables.pluck(:mode).include?(mode.to_s)
      availables.create!(mode: YamsCore::Available.modes[mode], meta_data: meta_data)
    end

    def remove_available_for(mode)
      availables.where(type: self, mode: mode).destroy_all
    end

  end
end
