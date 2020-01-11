class AddMetaDataAvailable < ActiveRecord::Migration[5.1]
  def change
    add_column :availables, :meta_data, :jsonb, default: {}

    add_index :availables, :meta_data, using: :gin   # see GIN vs GiST
  end
end
