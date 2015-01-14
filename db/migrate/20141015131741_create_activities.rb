class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer   :code
      t.string    :name
      t.text      :description
      t.integer   :status
      t.integer   :duration
      t.time      :effort
      t.integer   :evaluation
      t.date      :start_date
      t.date      :end_date
      t.integer   :assigned_id
      t.integer   :list_id
      t.integer   :milestone_id

      t.timestamps
    end
  end
end
