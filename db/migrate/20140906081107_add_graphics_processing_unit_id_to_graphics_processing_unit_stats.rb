class AddGraphicsProcessingUnitIdToGraphicsProcessingUnitStats < ActiveRecord::Migration
  def change
    add_column :graphics_processing_unit_stats, :graphics_processing_unit_id, :integer
  end
end
