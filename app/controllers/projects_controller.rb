class ProjectsController < ApplicationController
  before_filter :set_project, except: [:index, :new, :create]
  before_filter :set_member

  def index
    @projects = Project.accessible_by(current_ability)
    if params[:type].to_s == 'archived'
      @projects = @projects.recent.archived
    elsif params[:type].to_s == 'all'
      @projects = @projects.recent.all
    else
      @projects = @projects.recent.active
    end

    @projects = @projects.search(
      name_or_code_or_projectable_of_User_type_name_or_projectable_of_User_type_last_name_or_projectable_of_User_type_username_or_projectable_of_Company_type_name_cont: params[:q].to_s
    ).result

    @projects  = @projects.page(params[:page]).per(10)
    @companies = current_user.my_companies
  end

  def show
    redirect_to last_planner_project_path(@project)
  end

  def new
    @project = Project.new
    @company = Company.new
  end

  def create
    @project = Project.new(project_params, status: :active)
    @project.project_members << ProjectMember.new(user: current_user, role: 'owner')

    @project.projectable = current_user if @project.projectable_type == 'User'

    if @project.save
      flash[:success] = 'El proyecto se ha creado exitosamente.'
      redirect_to members_project_path(@project)
    else
      flash[:danger] = 'Hubo un error al crear el proyecto.'
      render 'new'
    end
  end

  def edit
    authorize! :update, @project
    @company = Company.new
  end

  def update
    authorize! :update, @project

    @project.projectable = current_user if project_params[:projectable_type] == 'User'

    if @project.update(project_params)
      flash[:success] = 'El proyecto se ha actualizado exitosamente.'
      redirect_to edit_project_path(@project)
    else
      flash[:danger] = 'Hubo un error al actualizar el proyecto.'
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @project

    if @project.destroy
      flash[:success] = 'El proyecto se ha eliminado exitosamente.'
      redirect_to root_path
    else
      flash[:danger] = 'Hubo un error al eliminar el proyecto.'
      render 'edit'
    end
  end

  def archive
    authorize! :archive, @project

    if @project.update(status: :archived)
      flash[:success] = 'El proyecto se ha archivado exitosamente.'
      redirect_to root_path
    else
      flash[:danger] = 'Hubo un error al archivar el proyecto.'
      render 'edit'
    end
  end

  def activate
    authorize! :archive, @project

    if @project.update(status: :active)
      flash[:success] = 'El proyecto se ha activado exitosamente.'
      redirect_to project_path(@project)
    else
      flash[:danger] = 'Hubo un error al activar el proyecto.'
      render 'edit'
    end
  end

  def plan
    @list      = List.new
    @milestone = Milestone.new
    @lists     = @project.lists.includes(:milestones).sort_by { |list| list.latest_milestone.end_date }
  end

  def members
    @members = @project.project_members.includes(:user).page(params[:page]).per(10)
    @roles   = ProjectMember.roles.reject { |r| r.id == :owner }
  end

  def meetings
    @meetings = @project.meetings.order(starts_at: :asc).page(params[:page]).per(10)
  end

  def last_planner
    if params[:date].blank?
      focal_date = Time.now.to_date
    else
      focal_date = Date.parse(params[:date])
    end

    @assigned   = @project.project_members.where(id: params[:assigned_id]).first
    @activities = @project.activities

    @activities = @activities.where(assigned: @assigned) unless @assigned.nil?

    @behind_activities          = @activities.behind(since: focal_date - 1.week, to: focal_date).nearest
    @one_week_ahead_activities  = @activities.ahead(since: focal_date, to: focal_date + 1.week).nearest
    @two_weeks_ahead_activities = @activities.ahead(since: focal_date + 1.week, to: focal_date + 2.weeks).nearest

    @focal_date = focal_date
  end

  def weekly_plan
    @assigned   = @project.project_members.where(user: current_user).first
    @activities = @project.activities.where(assigned: @assigned).without_constraints.scheduled
  end

  private

  def project_params
    params.require(:project).permit(
      :name, :description, :status, :projectable_id, :projectable_type
    )
  end

  def set_project
    @project = Project.find(params[:id])
    authorize! :read, @project
  end

  def set_member
    @member = current_user.project_members.where(project: @project).first
  end
end
