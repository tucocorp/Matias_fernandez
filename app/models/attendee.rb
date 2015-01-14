class Attendee < ActiveRecord::Base

  enum status: [:pending, :accepted, :refused]

  #
  # Associations
  #

  has_many :topics

  belongs_to :user
  belongs_to :meeting

  delegate :full_name, :short_name, :email, to: :user

  #
  # Callbacks
  #

  before_create :generate_token

  #
  # Instance methods
  #

  def generate_token
    self.token = loop do
      random_token = SecureRandom.uuid.gsub!('-', '')
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def human_status
    I18n.t("attendee.statuses.#{status}")
  end
end
