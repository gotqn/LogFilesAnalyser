class CreateLogEventTypes < ActiveRecord::Migration
  def change
    create_table :log_event_types do |t|
      t.string :event_type

      t.timestamps
    end
  end
end
