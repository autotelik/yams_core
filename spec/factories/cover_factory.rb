# frozen_string_literal: true

FactoryBot.define do
  factory :cover, class: YamsCore::Cover do
    image { fixture_file_upload(fixture_file('test_image.jpg'), 'image/jpeg') }
    association :owner, factory: :user
  end
end
