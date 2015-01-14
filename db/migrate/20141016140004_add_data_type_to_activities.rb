class AddDataTypeToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :data_type, :integer, after: :end_date
  end
end
