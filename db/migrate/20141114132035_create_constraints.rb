class CreateConstraints < ActiveRecord::Migration
  def change
    create_table :constraints do |t|
      t.string   :name
      t.datetime :end_date
      t.integer  :status,      default: 0
      
      t.integer  :category_id
      t.integer  :activity_id
      t.integer  :assigned_id

      t.timestamps
    end
  end
end
