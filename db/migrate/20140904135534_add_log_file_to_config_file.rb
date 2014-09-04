class AddLogFileToConfigFile < ActiveRecord::Migration
  def change
    add_column :config_files, :log_file_id, :integer
  end
end
