class Constraint < ActiveRecord::Base
  enum status: [ :pending, :unremoved, :removed ]

  #
  # Associations
  #

  belongs_to  :activity
  belongs_to  :category, class_name: 'ProjectCategory'
  belongs_to  :assigned, class_name: 'ProjectMember', foreign_key: 'assigned_id'

  has_and_belongs_to_many :issues

  delegate :project, to: :activity

  #
  # Validations
  #

  validates :name, :end_date, :category_id, presence: true

  #
  # Scopes
  #

  scope :nearest  , -> { order(end_date: :asc) }
  scope :upcoming , -> { where('constraints.end_date >= ?', Time.now.to_date) }
end
