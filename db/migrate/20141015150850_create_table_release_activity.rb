class CreateTableReleaseActivity < ActiveRecord::Migration
  def change
    create_table :release_activities, id: false do |t|
      t.integer :released_by
      t.integer :release_to

      t.timestamps
    end
  end
end
