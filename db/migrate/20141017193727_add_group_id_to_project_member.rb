class AddGroupIdToProjectMember < ActiveRecord::Migration
  def change
  	add_column :project_members, :group_id, :integer, after: :user_id
  	remove_column :project_members, :role
  end
end
