class AddMeetingIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :meeting_id, :integer, after: :milestone_id
  end
end
