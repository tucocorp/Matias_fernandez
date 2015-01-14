class FixColumDefault < ActiveRecord::Migration
  def change
    change_column :activities , :evaluation, :integer, :default => 0
  	change_column :activities , :status    , :integer, :default => 0
  	change_column :projects   , :status    , :integer, :default => 0
  	change_column :milestones , :lastest   , :boolean, :default => false
  	remove_column :companies  , :status	   , :string
  end
end
