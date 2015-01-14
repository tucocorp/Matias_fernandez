class ChangeColumnsToProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :creator_id, :projectable_id
    rename_column :projects, :creator_type, :projectable_type
  end
end
