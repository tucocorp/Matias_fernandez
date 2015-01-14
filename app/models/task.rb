class Task < ActiveRecord::Base
  
  #
  # Associations
  #

  has_many    :comments, as: :commentable
  
  belongs_to  :activity
  belongs_to  :assigned_member, class_name: 'ProjectMember', foreign_key: 'assigned_id'

  #
  # Validates
  #

  validates :name, :description, :start_date, :end_date, :assigned_id, :activity_id , presence: true
end
