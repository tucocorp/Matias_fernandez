class CreateUnitWorks < ActiveRecord::Migration
  def change
    create_table :unit_works do |t|
      t.date 	:start_date
      t.date 	:end_date
      t.integer :activity_id

      t.timestamps
    end
  end
end
