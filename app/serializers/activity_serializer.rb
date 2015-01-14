class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :assigned_id, 
             :start_date, :end_date, :date_type, :status

  has_one  :assigned
  has_many :constraints
end
