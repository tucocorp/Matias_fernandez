class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string   :name
      t.text     :description
      t.string   :location

      t.datetime :starts_at
      t.datetime :ends_at

      t.integer  :milestone_id

      t.timestamps
    end
  end
end
