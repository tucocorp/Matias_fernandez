class RemoveProjectGroups < ActiveRecord::Migration
  def change
    remove_column :project_members, :project_group_id
    add_column    :project_members, :role, :string, after: :user_id
  end
end
