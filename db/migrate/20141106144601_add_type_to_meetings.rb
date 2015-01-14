class AddTypeToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :type, :integer, default: 0, nulll: false, after: :location
  end
end
