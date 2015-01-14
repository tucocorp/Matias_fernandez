class CompanyMemberSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :role
end
