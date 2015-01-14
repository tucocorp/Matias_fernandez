class AddColumnToProject < ActiveRecord::Migration
  def change
    add_column :projects, :creator_type, :string, after: :status
    rename_column :projects, :company_id, :creator_id
  end
end
