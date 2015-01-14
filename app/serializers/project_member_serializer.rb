class ProjectMemberSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :short_name, :role
end
