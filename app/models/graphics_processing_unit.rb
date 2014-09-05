class GraphicsProcessingUnit < ActiveRecord::Base

  # Relationships
  belongs_to :log_file
  has_many :graphics_processing_unit_stats, dependent: :destroy

end
