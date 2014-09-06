class ChangeJsonFormatInConfFiles < ActiveRecord::Migration
  def up
    change_column :config_files, :json, :text
  end

  def down
    change_column :config_files, :json, :string
  end
end
