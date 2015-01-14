class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer   :code
      t.string    :name
      t.text      :description
      t.date      :start_date
      t.date      :end_date
      t.integer   :assigned_id
      t.integer   :activity_id

      t.timestamps
    end
  end
end
