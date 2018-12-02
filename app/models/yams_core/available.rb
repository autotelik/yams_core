# frozen_string_literal: true
module YamsCore
  class Available < ApplicationRecord
    belongs_to :type, polymorphic: true, inverse_of: :availables

    enum concept: %i[free commercial download playlist]

    before_create do
      self.on ||= DateTime.now
    end

  end
end
