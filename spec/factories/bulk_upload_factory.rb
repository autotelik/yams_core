# frozen_string_literal: true
include ActionDispatch::TestProcess

FactoryBot.define do
  factory :bulk_upload, class: YamsCore::BulkUpload do
    association   :user

    spreadsheet { fixture_file_upload(fixture_file('aqwan_33_tracks.xls'), 'application/vnd.ms-excel') }
  end
end
