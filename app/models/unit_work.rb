class UnitWork < ActiveRecord::Base

  #
  # Associations
  #

  belongs_to  :activity
  
  #
  # Validates
  #

  validates :start_date, :end_date, :activity_id , presence: true
end
