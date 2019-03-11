# frozen_string_literal: true
module YamsCore

  class Track::BulkUploadsController < ApplicationController

    before_action :authenticate_user!

    # GET /tracks/new
    def new
      @bulk_upload = BulkUpload.new(user: current_user)
    end

    def create
      @bulk_upload = BulkUpload.new(bulk_upload_params).tap do |b|
        b.user = current_user
      end

      respond_to do |format|
        if @bulk_upload.save

          begin
            Rails.logger.debug("Starting bulk upload for user #{current_user}")
            YamsCore::BulkUploadWorker.perform_async(@bulk_upload.id)

          rescue Redis::CannotConnectError => x
            Rails.logger.error("Redis DOWN - bulk upload not completed #{x.message}")
          rescue  => x
            Rails.logger.error("UNHANDLED - bulk upload not completed #{x.message}")
          end

          format.html { render :new, notice: 'Bulk upload was started. You can safely navigate away from this page.' }
          format.json { render :show, status: :created, location: @bulk_upload }
        else
          format.html do
            render :new, notice: 'Bulk upload failed.'
          end
          format.json { render json: @bulk_upload.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def bulk_upload_params
      params.require(:bulk_upload).permit(:spreadsheet)
    end

  end

end
