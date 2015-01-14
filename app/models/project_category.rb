class ProjectCategory < ActiveRecord::Base

  belongs_to :project
  has_many :constraints
end
