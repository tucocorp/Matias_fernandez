class Project < ActiveRecord::Base

  enum status: [ :active, :archived ]

  #
  # Associations
  #

  belongs_to  :projectable, polymorphic: true

  has_many    :lists
  has_many    :project_categories
  has_many    :project_members, dependent: :destroy

  has_one     :owner        , -> { where(permission: 'owner') } , class_name: 'ProjectMember'

  has_many    :meetings
  has_many    :phases       , -> { where(list_type: 0) }        , class_name: 'List'
  has_many    :components   , -> { where(list_type: 1) }        , class_name: 'List'

  has_many    :members      , through: :project_members         , source: :user
  has_many    :milestones   , through: :lists
  has_many    :activities   , through: :lists

  #
  # Validations
  #

  validates :name, :projectable_id, presence: true

  after_create :add_categories

  #
  # Scopes
  #

  scope :recent, -> { order(created_at: :desc) }
  
  scope :user_in_projects, ->(user) {
    where("
      (
        SELECT COUNT(*)
        FROM project_members AS pm
        WHERE pm.user_id = :user_id
        AND pm.project_id = projects.id
      ) > 0
    ", user_id: user.id)
  }

  #
  # Instance methods
  #

  def companyProject?
    return true if self.projectable_type == 'Company'
  end

  def code
    "P-#{id.to_s.rjust(4, '0')}"
  end

  def human_status
    I18n.t('statuses.' + status)
  end

  def is_member?(user)
    if self.project_members.where(user: user).first
      true
    else
      false
    end
  end

  def is_owner?(user)
    if self.project_members.where(user: user).first.role?(:owner)
      true
    else
      false
    end
  end

  def add_categories
    cats = [
      "Precedence - Precedence",
      "Disponibilidad - Availability",
      "Capacidad - Capacity",
      "Prerrequisitos - Prerequisite",
      "Materiales y Documentación - Material",
      "Aprobación - Approval",
      "Cambio de Prioridad - Change Priority",
      "Esfuerzo - Labour",
      "Equipamiento - Equipment",
      "Diseño - Design",
      "Pedido tardío - Submital (late request)"
    ]

    cats.each do |cat|
      self.project_categories.create(name: cat)
    end

  end
end
