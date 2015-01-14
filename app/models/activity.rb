class Activity < ActiveRecord::Base
  include Commentable

  attr_accessor :raw_effort

  #
  # Configurations
  #

  enum status:      [ :pending, :finished, :unfinished ]
  enum evaluation:  [ :unevaluated, :refused, :accepted ]
  enum date_type:   [ :calendar, :working ]
  
  #
  # Associations
  #

  has_many    :tasks
  has_many    :constraints
  has_many    :unit_works
  has_many 	  :issues

  belongs_to  :milestone
  belongs_to  :meeting
  belongs_to  :list
  
  belongs_to  :assigned, class_name: 'ProjectMember', foreign_key: 'assigned_id'

  has_and_belongs_to_many :released_by , class_name: 'Activity', association_foreign_key: 'released_by', foreign_key: 'release_to', join_table: 'release_activities'
  has_and_belongs_to_many :release_to , class_name: 'Activity', association_foreign_key: 'release_to', foreign_key: 'released_by', join_table: 'release_activities'

  delegate :project, to: :list

  #
  # Validates
  #

  validates :name, presence: true

  #
  # Callbacks
  #

  before_create :format_effort

  #
  # Scopes
  #

  scope :nearest  , -> { order(end_date: :asc) }
  scope :upcoming , -> { where('activities.end_date >= :today', today: Time.now.to_date) }

  scope :behind , ->(dates = {}) { 
    dates[:to]    ||= Time.now.to_date
    dates[:since] ||= (dates[:to] - 1.week).to_date

    where(end_date: dates[:since]..dates[:to])
  }

  scope :ahead  , ->(dates = {}) {
    dates[:since] ||= Time.now.to_date
    dates[:to]    ||= (dates[:since] + 1.week).to_date

    where(end_date: (dates[:since])..(dates[:to]))
  }

  scope :without_constraints, -> {
    where("(
      SELECT COUNT(c.id)
      FROM constraints AS c
      WHERE c.activity_id = activities.id
      AND c.status = 0
    ) = 0" )
  }

  scope :scheduled, -> {
    where('end_date IS NOT NULL AND start_date IS NOT NULL')
  }

  #
  # Instance methods
  #

  def code
    "A-#{id.to_s.rjust(4, '0')}"
  end

  def format_effort
    unless raw_effort.blank?
      time    = raw_effort.split(':')
      hours   = time.first.to_i
      minutes = time.second.to_i

      self.effort = (hours * 60) + minutes
    end
  end

  def human_status
    return I18n.t("statuses.constraints") if constraints.pending.any?
    I18n.t("statuses.#{status}")
  end

  def duration_in_hours
    "#{(end_date - start_date).to_i * 24}:00"
  end
end
