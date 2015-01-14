class MilestonesController < ApplicationController
  before_filter :set_milestone, except: [:new, :create]
  before_filter :set_project

  def show
    authorize! :read, @milestone

    respond_to do |format|
      format.json { render json: @milestone }
      format.html 
    end
  end
  
  def new
    @milestone = Milestone.new
  end

  def create
    @milestone = @list.milestones.new(milestone_params)
    authorize! :create, @milestone

    if @milestone.save
      flash[:success] = 'Se agregó un hito correctamente.'
      redirect_to plan_project_path(@project)
    else
      flash[:danger] = 'Hubo un error al crear un hito.'
      redirect_to plan_project_path(@project)
    end
  end

  def edit
  end

  def update
	if @milestone.update(milestone_params) 
      flash[:success] = 'Se editó el hito correctamente.'
      redirect_to plan_project_path(@project)
    else
      flash[:danger] = 'Hubo un error al editar el hito.'
      redirect_to plan_project_path(@project)
    end
  end

  def destroy
    authorize! :destroy, @milestone

    if @milestone.latest?
      flash[:danger] = 'No puedes eliminar este hito'
      redirect_to plan_project_path(@project) and return
    end

    if @milestone.destroy
      flash[:success] = 'El hito se eliminó correctamente'
    else
      flash[:danger] = 'Hubo un error al eliminar el hito'
    end
    
    redirect_to plan_project_path(@project)
  end

  def start_evaluation
    authorize! :update, @project

    activities = @milestone.activities

    if activities.empty?
      flash[:danger] = 'No se puede enviar a evaluación, por qué no existe ninguna actividad asignada.'
    else
      members = @project.project_members
      flash[:success] = 'Evaluación enviada exitosamente'
    end

    redirect_to milestone_path(@milestone)
  end

  private

  def milestone_params
    params.require(:milestone).permit(:end_date, :name, :assigned_id)
  end

  def set_milestone
    @milestone = Milestone.find(params[:id])
    @list = @milestone.list
    @project = @list.try(:project)
  end

  def set_project
    @list ||= List.find(params[:list_id])
    @project ||= @list.project
  end
end

