class AddLogFileToLogFiles < ActiveRecord::Migration
  def change
    add_column :log_files, :log_file, :string
  end
end
