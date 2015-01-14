class ProjectMember < ActiveRecord::Base  
  ROLES = %i[collaborator manager owner]

  #
  # Associations
  #

  belongs_to :project
  belongs_to :user

  delegate   :full_name, :short_name, :email, to: :user

  has_many   :activities  , foreign_key: 'assigned_id'
  has_many   :constraints , foreign_key: 'assigned_id'

  #
  # Validations
  #

  validates :project, :user, presence: true
  validates :role, inclusion: { in: ROLES.map { |r| r.to_s } }
  validate  :owner_uniqueness

  #
  # Class methods
  #

  def self.roles
    ROLES.map { |role| OpenStruct.new(id: role, name: I18n.t("project_roles.#{role}")) }
  end

  #
  # Instance methods
  #

  def role?(base_role)
    return false if !ROLES.include?(base_role.to_sym) || role.blank?
    ROLES.index(base_role.to_sym) <= ROLES.index(role.to_sym)
  end

  def human_role
    I18n.t("project_roles.#{role}")
  end

  private

  def owner_uniqueness
    if project.project_members.exists?(role: :owner) && role.to_sym == :owner
      errors.add(:role, 'Ya existe un propietario')
    end
  end
end
