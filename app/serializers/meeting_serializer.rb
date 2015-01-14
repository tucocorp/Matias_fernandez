class MeetingSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :location, :milestone_id, :type,
             :project_id, :started_at, :ended_at, :evaluation_ends_at,
             :status, :is_attendee

  def is_attendee
    scope.is_attendee?(object)
  end
end
