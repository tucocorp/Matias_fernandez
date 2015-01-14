class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :rut, :string, after: :description
    add_column :companies, :business_name, :string, after: :rut
    add_column :companies, :website, :string, after: :business_name
  end
end
