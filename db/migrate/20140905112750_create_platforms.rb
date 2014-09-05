class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :vendor
      t.string :name
      t.string :version
      t.references :log_file, index: true

      t.timestamps
    end
  end
end
