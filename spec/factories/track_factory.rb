# frozen_string_literal: true
include ActionDispatch::TestProcess

FactoryBot.define do
  factory :track, class: YamsCore::Track do
    title         { 'photon histories' }
    description   { 'My House Track' }
    association   :user

    trait :with_audio_upload_fixture do
      audio { fixture_file_upload(fixture_file('test.wav'), 'audio/x-wav') }
    end

    trait :with_audio do
      after(:build) do |t|
        t.attach_audio_file(fixture_file('test.wav'))
      end
    end

    trait :with_cover do
      association :cover, factory: :cover
    end

    trait :available_for_radio do
      after(:create) do |t, _evaluator|
        t.availables << YamsCore::Available.create(mode: :radio, on: DateTime.now)
      end
    end

    trait :available_for_download do
      after(:create) do |t, _evaluator|
        t.availables << create(:available, mode: :download)
      end
    end
  end

  factory :track_max, parent: :track do
    length { 348 }
    permalink { 'permalink_url' }
    bitrate {1}
    release_year {1}
    release_month {1}
    release_day {1}
    original_format {'MyString'}
    original_content_size {1}
    license { nil }
  end
end
