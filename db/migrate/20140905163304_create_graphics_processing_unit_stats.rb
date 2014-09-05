class CreateGraphicsProcessingUnitStats < ActiveRecord::Migration
  def change
    create_table :graphics_processing_unit_stats do |t|
      t.string :average
      t.integer :accepted
      t.integer :rejected
      t.integer :hardware_errors
      t.string :work_utility
      t.string :last_five_seconds
      t.references :GraphicsProcessingUnit, index: false

      t.timestamps
    end
  end
end
