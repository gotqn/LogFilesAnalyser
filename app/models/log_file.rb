class LogFile < ActiveRecord::Base

  # Uploader
  mount_uploader :log_file, LogFileUploader

  # Relationships
  has_one :AccessType

  # Methods

  def get_access_type_name_by_id
    AccessType.find(access_type_id).name
  end

end
