# frozen_string_literal: true

module Yams
  module RandomSeed
    extend ActiveSupport::Concern

    def set_rand_cookie
      return if cookies[:rand_seed].present?

      # Time will determine how quickly the randomisation resets
      cookies[:rand_seed] = { value: rand, expires: 1.second.from_now }
    end
  end
end
