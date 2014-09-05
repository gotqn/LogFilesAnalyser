class CreateLogEvents < ActiveRecord::Migration
  def change
    create_table :log_events do |t|
      t.integer :row_number
      t.string :event
      t.references :log_event_type, index: true

      t.timestamps
    end
  end
end
