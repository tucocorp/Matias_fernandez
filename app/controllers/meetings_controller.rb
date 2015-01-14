class MeetingsController < ApplicationController
  before_filter      :attendee_by_token, only: [:accept, :refuse]
  skip_before_filter :authenticate_user!, only: [:refuse, :accept]

  before_filter :set_data, only: [:new, :create]
  before_filter :set_meeting, except: [:new, :create]

  def show
    @list = @meeting.milestone.list
  end

  def edit
    authorize! :update, @meeting

    @list = @meeting.milestone.list
  end

  def new
    @meeting = Meeting.new(meeting_get_params)
    @meeting.topics.build(name: 'Identificación de actividades y restricciones', duration: 90)

    if @meeting.pull_planning?
      @meeting.name      = "#{I18n.t('meeting.pull_name')}: #{@list.name}"
      
      @meeting.starts_at = Time.zone.now.tomorrow
      @meeting.ends_at   = Time.zone.now.tomorrow + (1.5).hours

      @meeting.attendees = @project.members.map { |member| Attendee.new(user_id: member.id) }
      @attendee_ids      = @project.members.map(&:id)
      @milestone         = @list.latest_milestone
    end
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.milestone = @list.latest_milestone
    @meeting.add_attendees(params[:user_ids])

    if @meeting.save
      @meeting.send_agenda! if (params[:send_notification].to_i == 1)
      flash[:success] = "Se ha creado una reunión para el día #{@meeting.starts_at.strftime('%d/%m/%Y')} a las #{@meeting.starts_at.strftime('%H:%M')} hrs"
      redirect_to meeting_path(@meeting)
    else
      flash[:danger] = 'Hubo problemas al crear la reunión'
      redirect_to plan_project_path(@project)
    end
  end

  def update
    @meeting.update_attendees(params[:user_ids])

    if @meeting.update(meeting_params)
      flash[:success] = 'La reunión se actualizó exitosamente'
      redirect_to meeting_path(@meeting)
    else
      flash[:danger] = 'La reunión no se pudo guardar'
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @meeting

    meeting = @meeting
    if @meeting.destroy
      flash[:success] = "Reunión para el día #{meeting.starts_at.strftime('%d/%m/%Y')} a las #{meeting.starts_at.strftime('%H:%M')} fue eliminada exitosamente"
      redirect_to meetings_project_path(@project)
    else
      flash[:danger] = "Hubo problemas para eliminar la reunión del día #{meeting.starts_at.strftime('%d/%m/%Y')} a las #{meeting.starts_at.strftime('%H:%M')}"
      redirect_to meeting_path(@meeting)  
    end
  end

  def accept
    if @attendee.accepted!
      @attendee.update_column(:confirmed_at, Time.now)
      flash[:success] = 'Has aceptado la invitación a la reunión'
    end
    
    redirect_to meeting_path(@meeting)
  end

  def refuse
    if @attendee.refused!
      @attendee.update_column(:confirmed_at, Time.now)
      flash[:success] = 'Has rechazado la invitación a la reunión'
    end

    redirect_to meeting_path(@meeting)
  end

  def activities
    authorize! :read, @meeting

    @activities = @meeting.activities
    @assigned = @project.project_members.where(id: params[:assigned_to]).first

    unless @assigned.nil?
      @activities = @activities.where(assigned_id: @assigned.id)
    end

    @activities.order(start_date: :asc)
  end

  def resend_invitations
    authorize! :update, @meeting
    @meeting.send_agenda!
    flash[:success] = 'Se han enviado las invitaciones'
    redirect_to meeting_path(@meeting)
  end

  def resend_minute
    authorize! :update, @meeting
    
    @meeting.send_minute!
    flash[:success] = 'Se ha reenviado la minuta'
    redirect_to meeting_path(@meeting)
  end

  def start
    authorize! :update, @meeting
    @meeting.start!
    redirect_to meeting_path(@meeting)
  end

  def stop
    authorize! :update, @meeting
    @meeting.end!
    @meeting.send_minute!
    redirect_to meeting_path(@meeting)
  end

  private

  def meeting_get_params
    params.permit(:project_id, :type)
  end

  def meeting_params
    params.require(:meeting).permit(
      :name, :starts_at_date, :starts_at_time, :ends_at_date,
      :ends_at_time, :location, :type, :milestone_id, :project_id,
      topics_attributes: [:id, :name, :duration, :description, :presenter_id]
    )
  end

  def set_data
    @project = Project.find(params[:project_id] || params[:meeting][:project_id])
    @list    = @project.lists.find(params[:list_id])
  end

  def set_meeting
    @meeting = Meeting.find(params[:id])
    @project ||= @meeting.project
    authorize! :read, @meeting
  end

  def attendee_by_token
    @attendee = Attendee.where(token: params[:token]).first
    user = @attendee.user

    if user && Devise.secure_compare(@attendee.token, params[:token].to_s)
      sign_in(user)
    end

    @meeting = @attendee.meeting
    authorize! :read, @meeting
  end
end
