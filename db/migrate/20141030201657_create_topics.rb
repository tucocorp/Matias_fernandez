class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string  :name
      t.text    :description
      t.integer :duration       # The unit is minutes

      t.integer :meeting_id
      t.integer :presenter_id

      t.timestamps
    end
  end
end
