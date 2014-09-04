class CreateLogFiles < ActiveRecord::Migration
  def change
    create_table :log_files do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
