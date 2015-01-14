class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.text    :name
      t.integer :activity_id

      t.timestamps
    end
  end
end
