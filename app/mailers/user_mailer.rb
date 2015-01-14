class UserMailer < ActionMailer::Base
  default from: ENV['DEVISE_MAIL_SENDER']

  def add_member(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "has sido agregado el proyecto #{project.name}")    
  end

  def invite_user()
    mail(to: @user.email, subject: "invitación a participar en octopull")    
  end

  def send_activity_group_assigned(project_member, activities)
    @activities = activities.order('start_date ASC')
    @user = project_member.user
    @project = project_member.project

    mail(to: @user.email, subject: 'Evaluación de tareas')
  end

  def send_time_expired(user)
    @user = user
    mail(to: @user.email, subject: 'Finalización de periodo de evaluación')
  end

  def warning_3_hours_left(user)
    @user = user
    mail(to: @user.email, subject: 'El periodo de evaluación esta por finalizar')
  end

  def member_evaluation_sent(activity_group)
    @activity_group = activity_group
    @user = activity_group.project_member.user

    mail(to: @user.email, subject: 'Evaluación enviada').deliver!
  end

  def manager_evaluation_sent(activity_group)
    @activity_group = activity_group
    @member = activity_group.project_member.user

    activity_group.project.members.where('project_members.role = "manager" OR project_members.role = "owner"').each do |user|
      @user = user
      mail(to: @user.email, subject: 'Evaluación enviada').deliver!
    end
  end
end
