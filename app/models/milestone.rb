class Milestone < ActiveRecord::Base
  #
  # Associations
  #

  has_many    :activities
  
  belongs_to  :list
  belongs_to  :assigned, class_name: 'ProjectMember', foreign_key: 'assigned_id'  

  #
  # Validations
  #

  validates :name, :end_date, presence: true

  #
  # Scopes
  #

  scope :nearest, -> { order(end_date: :asc) }

  #
  # Instance methods
  #

  def code
    "H-#{id.to_s.rjust(4, '0')}"
  end
end
