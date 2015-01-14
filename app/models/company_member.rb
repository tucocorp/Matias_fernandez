class CompanyMember < ActiveRecord::Base
  ROLES = %i[collaborator manager pmo]

  #
  # Associations
  #

  belongs_to :company
  belongs_to :user

  delegate :full_name, :email, to: :user

  #
  # Validations
  #

  validates :company, :user, presence: true
  validates :role, inclusion: { in: ROLES.map { |r| r.to_s } }

  def role?(base_role)
    return false if !ROLES.include?(base_role.to_sym) || role.blank?
    ROLES.index(base_role.to_sym) <= ROLES.index(role.to_sym)
  end

  def self.roles
    ROLES.map { |role| OpenStruct.new(id: role, name: I18n.t("company_roles.#{role}")) }
  end

  def human_role
    I18n.t("company_roles.#{role}")
  end
end
