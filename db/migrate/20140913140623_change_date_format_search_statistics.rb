class ChangeDateFormatSearchStatistics < ActiveRecord::Migration
  def up
    change_column :search_statistics, :start_date, :date
  end

  def down
    change_column :search_statistics, :start_date, :datetime
  end
end
