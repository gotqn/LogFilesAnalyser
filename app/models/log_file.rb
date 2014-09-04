class LogFile < ActiveRecord::Base

  # Uploader
  mount_uploader :log_file, LogFileUploader

  # Relationships
  has_one :access_type
  has_one :config_file

  # Update relationships models
  accepts_nested_attributes_for :config_file, allow_destroy: true

  # Methods

    def get_access_type_name
      AccessType.find(access_type_id).name
    end

    def get_config_file
      ConfigFile.find_by_log_file_id(id).json
    end

end
