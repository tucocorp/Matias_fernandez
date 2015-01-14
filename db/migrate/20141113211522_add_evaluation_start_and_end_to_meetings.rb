class AddEvaluationStartAndEndToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :evaluation_ends_at, :datetime, after: :ended_at
  end
end
