class ChangePermisionToRoleFromCompanyMembers < ActiveRecord::Migration
  def change
    rename_column :company_members, :permission, :role
  end
end
