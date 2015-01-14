class ActivitiesController < ApplicationController
  before_filter :set_activity, except: [:new, :create, :accept_all ]
  before_filter :set_data, except: [:accept_all]

  # respond_to :html, :json

  def new
    @activity = Activity.new
    @user = User.new
  end

  def create
    # if @meeting.ended?
    #   flash[:danger] = 'La reunión ya finalizó, no es posible agregar más actividades'
    #   redirect_to meeting_path(@meeting) and return
    # end

    authorize! :create, Activity
    @activity = @list.activities.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html do
          flash[:success] = "La actividad se ha creado exitosamente"
          redirect_to(meeting_path(@activity.meeting))
        end
        format.json { render json: @activity }
      else
        format.html do 
          flash[:danger] = "Hubo problemas al crear una actividad"
          redirect_to(meeting_path(@activity.meeting))
        end
        format.json { render json: { errors: @activity.errors } }
      end
    end
  end

  def edit
    authorize! :update, @activity
    @user = User.new
  end

  def show
    meta = {
      can_update: can?(:update, @activity),
      period: (@activity.end_date > Time.now.to_date) ? 'ahead' : 'behind'
    }

    render json: @activity, root: :activity, meta: meta
  end

  def update
    authorize! :update, @activity

    respond_to do |format|
      if @activity.update(activity_params)
        format.json { render json: @activity }
        format.html { redirect_to(milestone_path(@milestone)) }
      else
        format.json { render json: { errors: @activity.errors } }
        format.html { redirect_to(milestone_path(@milestone)) }
      end
    end
  end

  def destroy
    authorize! :destroy, @activity

    respond_to do |format|
      if @activity.destroy
        format.html do
          flash[:success] = 'La actividad se eliminó correctamente.'
          redirect_to meeting_path(@activity.meeting)
        end

        format.json { render nothing: true, status: 204 }
      else
        format.html do
          flash[:danger] = 'Hubo un error al elimnar la actividad.'
          redirect_to meeting_path(@activity.meeting)
        end

        format.json { render json: { errors: @activity.errors } }
      end
    end
  end

  def pending
    authorize! :pending, @activity
    @activity.pending!

    redirect_to last_planner_project_path(@project)
  end

  def completed
    authorize! :complete, @activity
    @activity.finished!

    redirect_to last_planner_project_path(@project)
  end

  def uncompleted
    authorize! :uncomplete, @activity
    @activity.unfinished!

    redirect_to last_planner_project_path(@project)
  end

  def accept
    if @activity.accepted!
      flash[:success] = 'Actividad aceptada correctamente'
    else
      flash[:danger] = 'Hubo un error al aceptar la actividad'
    end

    redirect_to activities_meeting_path(@activity.meeting)
  end

  def refuse
    if @activity.refused!
      flash[:success] = 'Actividad rechazada'
    else
      flash[:danger] = 'Hubo un error al rechazar la actividad'
    end

    redirect_to activities_meeting_path(@activity.meeting)
  end

  def accept_all
    @meeting = Meeting.find(params[:meeting_id])
    @project = @meeting.project

    @activities = @meeting.activities
    @assigned   = @project.project_members.where(user: current_user).first

    @activities.each do |activity|
      # abort(YAML::dump(@assigned))
      if activity.assigned == @assigned
        activity.accepted!
      end
    end

    redirect_to activities_meeting_path(@meeting)
  end

  private

  def activity_params
    params.require(:activity).permit(
      :name, :description, :status, :duration, :date_type,
      :raw_effort, :start_date, :end_date, :assigned_id, :list_id,
      :meeting_id, :milestone_id
    )
  end

	def set_activity
    @activity      = Activity.find(params[:id])
    @meeting       = Meeting.where(id: params[:meeting_id]).first

    @milestone     = @activity.try(:milestone) || Milestone.find(params[:milestone_id])
    @list 				 = @milestone.list
    @project       = @list.project
  end

  def set_data
    @milestone    ||= Milestone.find(params[:milestone_id])
    @list         ||= @milestone.list
    @project      ||= @list.project
    @meeting      ||= Meeting.where(id: params[:meeting_id]).first
  end

end
