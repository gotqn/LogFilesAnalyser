class AddLogFileIdToLogEvents < ActiveRecord::Migration
  change_table :log_events do |t|
    t.references :log_file, index: true
  end
end


