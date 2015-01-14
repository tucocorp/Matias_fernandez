class List < ActiveRecord::Base
  #
  # Configurations
  #
  
  enum list_type: [:phase, :component]

  #
  # Associations
  #
  
  has_many   :activities
  has_many   :milestones, dependent: :destroy
  
  belongs_to :project

  #
  # Validations
  #

  validates :name, :project_id, presence: true
  validates_associated :milestones
  

  #
  # Callbacks
  #

  #
  # Instance methods
  #

  def code
    "F-#{id.to_s.rjust(4, '0')}"
  end

  def full_name
    "#{code} - #{name}"
  end

  def milestone_activities(actual, previous = nil)
    if previous.nil?
      self.activities.order(end_date: :asc).where('end_date <= ?', actual.end_date)
    else
      self.activities.order(end_date: :asc).where('end_date > :previous_date AND end_date <= :actual_date', previous_date: previous.end_date, actual_date: actual.end_date)
    end
  end

  def human_type
    I18n.t("list_type.#{list_type}")
  end

  def latest_milestone
    self.milestones.where(latest: true).first
  end
end
