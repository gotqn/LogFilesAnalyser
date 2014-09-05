class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
      t.string :name
      t.references :log_file, index: true

      t.timestamps
    end
  end
end
