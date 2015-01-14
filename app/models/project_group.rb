class ProjectGroup < ActiveRecord::Base
  # enum permission: [:read, :write, :admin]

  #
  # Associations
  #

  # belongs_to  :project
  # has_many    :project_members
  # has_many    :members, through: :project_members , source: :user

  #
  # Validations
  #

  # validates :permission, inclusion: { in: ROLES.map { |r| r.to_s } }

  #
  # Class methods
  #

  # def self.roles
  #   ROLES.map { |role| OpenStruct.new(id: role, name: I18n.t("project_roles.#{role}")) }
  # end

  #
  # Instance methods
  #

  # def role?(base_role)
  #   return false if !ROLES.include?(base_role.to_sym) || role.blank?
  #   ROLES.index(base_role.to_sym) <= ROLES.index(role.to_sym)
  # end

  # def human_role
  #   I18n.t("project_roles.#{role}")
  # end
end
