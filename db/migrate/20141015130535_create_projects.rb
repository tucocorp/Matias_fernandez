class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :code
      t.string  :name
      t.text    :description
      t.integer :status
      t.integer :company_id

      t.timestamps
    end
  end
end
