class AddProjectIdToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :project_id, :integer, after: :milestone_id
  end
end
