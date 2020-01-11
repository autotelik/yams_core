# frozen_string_literal: true
module YamsCore
  class Available < ApplicationRecord
    belongs_to :type, polymorphic: true, inverse_of: :availables

    enum mode: %i[radio download playlist stream]

    store_accessor :meta_data, :price, :ccy

    before_create :init_meta_data

    private

    def init_meta_data
      self.meta_data ||= {}.with_indifferent_access

      self.on ||= DateTime.now
    end

  end
end


