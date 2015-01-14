class CreateCompanyMembers < ActiveRecord::Migration
  def change
    create_table :company_members do |t|
      t.integer :user_id
      t.integer :company_id
      t.string :permission

      t.timestamps
    end
  end
end
