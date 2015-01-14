class AddConfirmedAtToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :confirmed_at, :datetime, after: :token
  end
end
