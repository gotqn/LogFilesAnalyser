class CreateGraphicsProcessingUnits < ActiveRecord::Migration
  def change
    create_table :graphics_processing_units do |t|
      t.string :name
      t.references :log_file, index: true

      t.timestamps
    end
  end
end
