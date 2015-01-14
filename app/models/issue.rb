class Issue < ActiveRecord::Base

  #
  # Associations
  #

  belongs_to :activity

  has_and_belongs_to_many :constraints

end
