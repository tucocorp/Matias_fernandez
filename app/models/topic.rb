class Topic < ActiveRecord::Base

  #
  # Associations
  #

  belongs_to :meeting
  belongs_to :presenter, class_name: 'Attendee', foreign_key: 'presenter_id'

  #
  # Validations
  #

  validates :name, :duration, presence: true

end
