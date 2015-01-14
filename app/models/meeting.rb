class Meeting < ActiveRecord::Base
  include DateTimeAttribute

  self.inheritance_column = nil
  
  enum type: [ :normal, :pull_planning ]
  date_time_attribute :starts_at, :ends_at

  #
  # Associations
  #

  has_many   :attendees, dependent: :destroy
  has_many   :topics
  has_many   :activities, dependent: :nullify
  has_many   :comments, as: :commentable
  has_many   :users, through: :attendees, source: :user

  belongs_to :milestone
  belongs_to :project

  accepts_nested_attributes_for :topics, allow_destroy: true

  #
  # Validations
  #

  validates :name, :starts_at, :ends_at, :milestone_id, presence: true

  validate :validate_attendees

  validates_associated :topics

  #
  # Scopes
  #

  scope :nearest  , -> { order(starts_at: :asc) }
  scope :upcoming , -> { where('meetings.starts_at >= ?', Time.now.to_date) }

  #
  # Instance methods
  #

  def add_attendees(user_ids)
    unless user_ids.nil?
      user_ids.each do |user_id|
        attendees.new(user_id: user_id.to_i)
      end
    end
  end

  def update_attendees(user_ids)
    old_ids    = attendees.map(&:user_id).map(&:to_s)
    new_ids    = user_ids - old_ids
    remove_ids = old_ids - user_ids

    add_attendees(new_ids)
    attendees.where(user_id: remove_ids).destroy_all
  end

  def to_ical
    cal = Icalendar::Calendar.new

    cal.event do |e|
      e.dtstart     = starts_at
      e.dtend       = ends_at
      e.summary     = name
      e.description = description
      e.organizer   = 'OctoPull'
      e.location    = location
      e.url         = Rails.application.routes.url_helpers.meeting_url(id, host: ENV['DEFAULT_HOST_URL'])
    end

    cal.publish
    cal.to_ical
  end

  def duration
    (((ends_at - starts_at) / 1.hour) * 60).to_i
  end

  def real_duration
    (((ended_at - started_at) / 1.hour) * 60).to_i
  end

  def start!
    update(started_at: Time.now)
  end

  def end!
    update(ended_at: Time.now, evaluation_ends_at: (Time.now + 24.hours))
  end

  def started?
    !started_at.nil?
  end

  def ended?
    !ended_at.nil?
  end

  def running?
    !started_at.nil? && ended_at.nil?
  end

  def in_evaluation?
    return false if evaluation_ends_at.nil?
    (Time.now < evaluation_ends_at)
  end

  def evaluation_ended?
    return false if evaluation_ends_at.nil?
    (Time.now > evaluation_ends_at)
  end

  def status
    if running?
      "running"
    elsif ended?
      "ended"
    elsif in_evaluation?
      "in_evaluation"
    elsif evaluation_ended?
      "evaluation_ended"
    else
      "scheduled"
    end        
  end

  def send_agenda!
    attendees.each do |attendee|
      Notificator.send_agenda(self, attendee)
    end
  end

  def send_minute!
    attendees.each do |attendee|
      Notificator.send_minute(self, attendee)
    end
  end

  def human_status
    I18n.t("statuses.#{status}")
  end

  private

  def validate_attendees
    errors.add(:meetings, "Deben haber participantes inscritos") if attendees.size <= 0
  end
end
