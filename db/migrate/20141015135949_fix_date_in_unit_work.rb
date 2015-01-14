class FixDateInUnitWork < ActiveRecord::Migration
  def change
  	change_column :unit_works, :start_date, :datetime
  	change_column :unit_works, :end_date, :datetime
  end
end
