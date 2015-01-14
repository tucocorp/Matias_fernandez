class ConstraintSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :end_date,
             :category_id, :assigned_id, :activity_id
end
