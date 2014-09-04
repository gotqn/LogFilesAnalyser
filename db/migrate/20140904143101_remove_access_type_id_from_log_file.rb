class RemoveAccessTypeIdFromLogFile < ActiveRecord::Migration
  def change
    remove_column :log_files, :access_type_id, :integer
  end
end
