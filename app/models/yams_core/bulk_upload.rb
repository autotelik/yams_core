# frozen_string_literal: true

module YamsCore
  class BulkUpload < ApplicationRecord
    belongs_to :user

    has_one_attached :spreadsheet

    validates_presence_of :spreadsheet, :user

    validates :spreadsheet, attached: true, content_type: %w{ application/vnd.ms-excel }
  end
end
