class CreateProjectCategories < ActiveRecord::Migration
  def change
    create_table :project_categories do |t|
      t.string  :name
      t.text    :description
      t.integer :project_id

      t.timestamps
    end
  end
end
