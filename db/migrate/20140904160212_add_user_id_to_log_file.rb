class AddUserIdToLogFile < ActiveRecord::Migration
  def change
    add_column :log_files, :user_id, :integer
  end
end
