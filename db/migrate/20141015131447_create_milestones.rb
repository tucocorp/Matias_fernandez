class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.text    :deliverable
      t.date    :end_date
      t.boolean :lastest
      t.integer :assigned_id
      t.integer :list_id

      t.timestamps
    end
  end
end
