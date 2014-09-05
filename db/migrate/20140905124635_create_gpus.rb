class CreateGpus < ActiveRecord::Migration
  def change
    create_table :gpus do |t|
      t.string :UDID
      t.string :name
      t.string :vendorID
      t.references :log_file, index: true

      t.timestamps
    end
  end
end
