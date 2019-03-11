class AddBulkUpload < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_uploads do |t|
      t.references :user, index: true
      t.timestamps
    end
  end
end
