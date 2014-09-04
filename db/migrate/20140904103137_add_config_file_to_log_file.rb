class AddConfigFileToLogFile < ActiveRecord::Migration
  def change
    add_column :log_files, :config_file_id, :integer
  end
end
