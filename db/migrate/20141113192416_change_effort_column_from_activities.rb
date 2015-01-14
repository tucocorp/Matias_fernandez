class ChangeEffortColumnFromActivities < ActiveRecord::Migration
  def up
    change_column :activities, :effort, :integer
  end

  def down
    change_column :activities, :effort, :time
  end
end
