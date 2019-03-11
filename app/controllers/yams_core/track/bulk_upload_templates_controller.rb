# frozen_string_literal: true
module YamsCore

  class Track::BulkUploadTemplatesController < ApplicationController

    before_action :authenticate_user!

    def show
      spreadsheet = File.read(File.join(YamsCore::Engine.root, 'config', 'templates', 'bulk_upload_template.xls'))

      send_data spreadsheet, filename: 'yams_bulk_upload_template.xls', :type =>  "application/vnd.ms-excel"
    end


    # TODO - Move to admin only
    def create

      config = DataShift::Configuration.new

      config.remove_rails = true

      generator = DataShift::ExcelGenerator.new(config: config)

      spreadsheet = StringIO.new

      generator.generate(spreadsheet, YamsCore::Track)

      send_data spreadsheet.string, :filename => "yourfile.xls", :type =>  "application/vnd.ms-excel"
    end

  end

end
