class FixColunmToProjectGroup < ActiveRecord::Migration
  def change
    rename_column :project_members, :group_id, :project_group_id
  end
end
