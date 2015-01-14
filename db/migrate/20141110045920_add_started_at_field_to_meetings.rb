class AddStartedAtFieldToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :started_at, :datetime, after: :project_id
    add_column :meetings, :ended_at  , :datetime, after: :started_at
  end
end
