# frozen_string_literal: true

FactoryBot.define do
  factory :default_cover, class: YamsCore::DefaultCover do
    image { fixture_file_upload(fixture_file('test_image.jpg'), 'image/jpeg') }
  end
end
