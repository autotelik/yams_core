# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: YamsCore::User do
    confirmed_at { Time.now }
    name  { Faker::Artist.name }
    email { Faker::Internet.unique.email }
    password { 'rspec123' }

    trait :with_avatar do
      avatar { fixture_file_upload(fixture_file('test_image.jpg'), 'image/jpeg') }
    end

    trait :admin do
      role { 'admin' }
    end
  end
end
