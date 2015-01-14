class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :initial
      t.string :name
      t.text   :description
      t.string :contact_name
      t.string :phone_number
      t.string :email
      t.string :status

      t.timestamps
    end
  end
end
