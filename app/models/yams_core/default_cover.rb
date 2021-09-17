# frozen_string_literal: true
module YamsCore
  class DefaultCover < ApplicationRecord

    # has_one_attached :image via
    include YamsCore::Covering

    enum kind: %i[album artist playlist track user]

    DefaultCover.kinds.each do |name, idx|
      define_singleton_method("for_#{name}") { where(kind: idx).first }
    end

  end
end
