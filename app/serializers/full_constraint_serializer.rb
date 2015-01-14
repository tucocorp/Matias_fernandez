class FullConstraintSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :end_date, :activity,
             :category_id, :assigned_id, :activity_id,
             :project_categories, :project_members

  def project_categories
    ActiveModel::ArraySerializer.new(object.project.project_categories, each_serializer: ProjectCategorySerializer)
  end

  def project_members
    ActiveModel::ArraySerializer.new(object.project.project_members, each_serializer: ProjectMemberSerializer)
  end
end
