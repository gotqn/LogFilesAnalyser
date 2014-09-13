class CreateSearchStatistics < ActiveRecord::Migration
  def change
    create_table :search_statistics do |t|
      t.column :runtime_in_minutes, :bigint
      t.datetime :start_date
      t.decimal :average_hashrate
      t.references :log_file, index: true

      t.timestamps
    end
  end
end
