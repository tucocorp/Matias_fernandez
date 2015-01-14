class User < ActiveRecord::Base
  attr_accessor :login

  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  mount_uploader :avatar, AvatarUploader

  #
  # Associations
  #

  has_many :attendees
  has_many :company_members
  has_many :project_members
  has_many :projects, as: :projectable
  
  has_many :companies     , through: :company_members
  has_many :my_companies  , -> { where(company_members: { role: 'pmo' }) }, source: :company, through: :company_members

  has_many :activities  , through: :project_members
  has_many :constraints , through: :project_members
  has_many :meetings    , through: :attendees

  #
  # Validations
  #

  validates :username, :name, :last_name, presence: true
  validates :username, uniqueness: { case_sensitive: false }

  #
  # Scopes
  #

  scope :locked      , -> { where('users.locked_at IS NOT NULL') }
  scope :enabled     , -> { where('users.locked_at IS NULL') }

  #
  # Callbacks
  #

  after_create :generate_access_token

  #
  # Class methods
  #

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.with_members(project)
    select("
      users.*, 
      (
        SELECT pm.id
        FROM  project_members AS pm 
        WHERE pm.user_id = users.id 
        AND   pm.project_id = #{project.id}
        LIMIT 1
      ) AS member_id"
    )
  end

  #
  # Instance methods
  #

  def full_name
    return email if username.blank?
    return username if name.blank? and last_name.blank?
    "#{name.capitalize} #{last_name.capitalize}"
  end

  def short_name
    return email if username.blank?
    return username if name.blank? and last_name.blank?
    "#{name.capitalize} #{last_name[0].upcase}."
  end

  def locked?
    (locked_at != nil)
  end

  def member
    ProjectMember.find(member_id) unless member_id.nil?
  end

  def is_attendee?(meeting)
    meeting.attendees.exists?(user_id: self.id)
  end

  def generate_access_token
    token = loop do
      random_token = Base64.encode64(SecureRandom.uuid)
      break random_token unless self.class.exists?(access_token: random_token)
    end

    update_column(:access_token, token)
  end
end
