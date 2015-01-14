class AddConfirmationStatusAndTokenToMeeting < ActiveRecord::Migration
  def change
    add_column :attendees, :status, :integer, null: false, default: 0, after: :user_id
    add_column :attendees, :token, :string, after: :status
  end
end
