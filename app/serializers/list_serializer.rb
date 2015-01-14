class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :project_id, :end_date

  def end_date
    object.milestones.first.try(:end_date)
  end
end
