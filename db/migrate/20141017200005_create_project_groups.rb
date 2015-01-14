class CreateProjectGroups < ActiveRecord::Migration
  def change
    create_table :project_groups do |t|
      t.string :name
      t.text :description
      t.integer :permission
      t.integer :project_id

      t.timestamps
    end
  end
end
