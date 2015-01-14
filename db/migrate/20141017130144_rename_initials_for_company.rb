class RenameInitialsForCompany < ActiveRecord::Migration
  def change
  	rename_column :companies, :initial, :initials
  end
end
