require 'datashift'

module YamsCore
  class BulkUploadWorker
    include Sidekiq::Worker

    def perform(bulk_upload_id)
     # byebug
      upload = YamsCore::BulkUpload.find(bulk_upload_id)

      loader = DataShift::ExcelLoader.new

      loader.configure_from_yaml(YAML.load(run_book, [Date, Time, Symbol]))

      ActiveStorage::Downloader.new( upload.spreadsheet).download_blob_to_tempfile { |tempfile| loader.run(tempfile, YamsCore::Track) }

      # TODO: At some point (Rails 6?) API will become .. spreadsheet.blob.open { |tempfile| loader.run(tempfile, YamsCore::Track) }
    end

    private

    def run_book
      @run_book ||= <<-EOS
data_flow_schema:
  Global:
    force_inclusion_of_columns: 'audio'
  'YamsCore::Track':
    nodes:
      - audio:
          index: 1
          operator: attach_audio_file
      - cover:
          index: 2
          operator: attach_cover
      - availables:
          index: 4    # TODO why is this necessary, can't datashift work it our from heading name
          operator: make_available_for
      EOS
    end

  end
end
