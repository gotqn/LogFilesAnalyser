class LogEvent < ActiveRecord::Base

  # Relationships
  belongs_to :log_event_type
  belongs_to :log_file

end
