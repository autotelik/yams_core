# frozen_string_literal: true

require 'rails_helper'

describe 'bulk uploads', type: :request do
  context 'POST' do
    context 'upload spreadsheet' do
      let(:test_user) { create(:user) }

      before do
        login_as(test_user, scope: :user)
      end
      include Shoulda::Matchers::ActionController

      it 'offers ability to generate a blank template spreadsheet or bulk upload a spreadsheet ' do
        get '/track/bulk_uploads/new'


        expect(response.body).to match(/input.*value="Upload"/)
        expect(response.body).to match(/input.*value="Generate Template"/)
      end

      it 'creates a new bulk upload with spreadsheet as an attachment', js: true do
        parameters = { bulk_upload: attributes_for(:bulk_upload) }
        expect { post '/track/bulk_uploads', params: parameters }.to change(YamsCore::BulkUpload, :count).by(1)

        expect(YamsCore::BulkUpload.last.spreadsheet.filename).to eq "aqwan_33_tracks.xls"
      end

      it 'calls a worker to perform actual upload ', js: true do
        parameters = { bulk_upload: attributes_for(:bulk_upload) }
        post '/track/bulk_uploads', params: parameters

        expect(YamsCore::BulkUploadWorker).to have_enqueued_sidekiq_job()
      end

    end
  end
end
