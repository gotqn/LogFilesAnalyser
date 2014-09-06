class RemoveGraphicsProcessingUnit < ActiveRecord::Migration
  def change
    remove_column :graphics_processing_unit_stats, :GraphicsProcessingUnit_id
  end
end
