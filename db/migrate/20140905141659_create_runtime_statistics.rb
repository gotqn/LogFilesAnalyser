class CreateRuntimeStatistics < ActiveRecord::Migration
  def change
    create_table :runtime_statistics do |t|
      t.string :stats
      t.references :log_file, index: true

      t.timestamps
    end
  end
end
