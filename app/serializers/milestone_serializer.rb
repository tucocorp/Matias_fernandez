class MilestoneSerializer < ActiveModel::Serializer
  attributes :id, :name, :latest, :end_date, :assigned_id

  has_one :list
end
