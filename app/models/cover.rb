# frozen_string_literal: true

class Cover < ApplicationRecord
  include YamsCore::Covering

  belongs_to :owner, polymorphic: true, required: false
end
