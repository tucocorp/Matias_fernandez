class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string  :code
      t.string  :name
      t.text    :description
      t.integer :list_type
      t.integer :project_id

      t.timestamps
    end
  end
end
