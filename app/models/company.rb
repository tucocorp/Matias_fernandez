class Company < ActiveRecord::Base
  include RailsSettings::Extend
  
  #
  # Associations
  #

  has_many  :projects, as: :projectable

  has_many  :company_members
  has_many  :members, through: :company_members, source: :user
  has_one   :owner, -> { where(permission: 'owner') }, class_name: 'CompanyMember'

  #
  # Validations
  #

  validates :name, :initials, presence: true

  #
  # Instance methods
  #

  alias_attribute :full_name, :name

  def code
    "E-#{id.to_s.rjust(4, '0')}"
  end

  def is_member?(user)
    if self.company_members.where(user: user).first
      true
    else
      false
    end
  end
end
