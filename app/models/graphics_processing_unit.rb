class GraphicsProcessingUnit < ActiveRecord::Base

  # Relationships
  belongs_to :log_file
  has_one :graphics_processing_unit_stat, dependent: :destroy

end
