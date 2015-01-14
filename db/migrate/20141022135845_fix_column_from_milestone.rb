class FixColumnFromMilestone < ActiveRecord::Migration
  def change
     rename_column :milestones, :lastest, :latest
     rename_column :milestones, :deliverable, :name
  end
end
