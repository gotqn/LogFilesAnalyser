class CreatePoolStatistics < ActiveRecord::Migration
  def change
    create_table :pool_statistics do |t|
      t.string :stats
      t.references :pool, index: true

      t.timestamps
    end
  end
end
