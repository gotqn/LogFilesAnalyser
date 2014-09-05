class Pool < ActiveRecord::Base

  # Relationships
  belongs_to :log_file
  has_many :pool_statistics, dependent: :destroy

end
