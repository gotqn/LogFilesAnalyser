class AddAccessTypeIdToLogFile < ActiveRecord::Migration
  def change
    add_column :log_files, :access_type_id, :integer
  end
end
