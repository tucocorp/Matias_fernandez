class ChangeRutFieldToUsername < ActiveRecord::Migration
  def change
    rename_column :users, :rut, :username
  end
end
