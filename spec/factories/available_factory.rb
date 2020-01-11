# frozen_string_literal: true
#
FactoryBot.define do
  factory :available, class: YamsCore::Available do
    mode { "free" }

    meta_data  {
      { price:  1000,     # approx 0.07 usd
        ccy:    :satoshi
      }
    }

    on { DateTime.now }

    association :type, factory: [:track, :with_audio]
  end

end
