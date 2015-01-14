class FixDateTimeFromAcitctivities < ActiveRecord::Migration
  def change
     rename_column :activities, :data_type, :date_type
  end
end
