class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    #
    # Projects
    #

    can :create, Project
    can :create, Company

    can :read, Project, Project.user_in_projects(user) do |project|
      project.project_members.exists?(user_id: user.id)
    end

    can [:update, :archive], Project do |project|
      pm = project.project_members.where(user_id: user.id).first
      pm.role?(:manager) unless pm.nil?
    end

    can :destroy, Project do |project|
      pm = project.project_members.where(user_id: user.id).first
      pm.role?(:owner) unless pm.nil?
    end

    #
    # Companies
    #

    can :update, Company do |company|
      cm = company.company_members.where(user_id: user.id).first
      cm.role?(:pmo) unless cm.nil?
    end

    #
    # Project Members
    #

    can [:update, :destroy], ProjectMember do |member|
      can? :update, member.project
    end

    #
    # Company Members
    #

    can [:update, :destroy], CompanyMember do |member|
      can? :update, member.company
    end

    #
    # Lists
    #

    can :manage, List do |list|
      can? :update, list.project
    end

    can :read, List do |list|
      can? :read, list.project
    end

    #
    # Milestones
    #

    can :manage, Milestone do |milestone|
      can? :manage, milestone.list
    end

    #
    # Meetings
    #

    can :read, Meeting do |meeting|
      can? :read, meeting.project
    end

    can [:update, :destroy], Meeting do |meeting|
      can? :update, meeting.project
    end

    #
    # Activity
    #

    can [:create, :update, :destroy], Activity do |activity|
      (can? :update, activity.list.project) || (activity.assigned == current_member(activity.project))
    end

    can [:complete, :uncomplete, :pending], Activity do |activity|
      can?(:update, activity.project) || (activity.assigned == current_member(activity.project))
    end
  end

  private

  def current_member(project)
    return nil if project.nil?
    project.project_members.where(user: @user).first
  end
end
