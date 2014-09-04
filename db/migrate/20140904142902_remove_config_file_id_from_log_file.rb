class RemoveConfigFileIdFromLogFile < ActiveRecord::Migration
  def change
    remove_column :log_files, :config_file_id, :integer
  end
end
