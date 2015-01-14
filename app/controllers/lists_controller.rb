class ListsController < ApplicationController
  before_filter :set_list, except: [:new, :create]
  before_filter :set_project

  def show
    authorize! :read, @list

    respond_to do |f|
      f.json { render json: @list }
      f.html 
    end
  end

  def new
    @list = List.new
  end

  def create
    @list = @project.lists.new(list_params)
    authorize! :create, @list

    milestone = @list.milestones.new(milestone_params)
    milestone.latest = true
    milestone.assigned = current_member

    if @list.save
      flash[:success] = 'Se ha creado una nueva fase exitosamente.'
    else
      flash[:danger] = 'Hubo un error al crear la fase/componente.'
    end

    redirect_to plan_project_path(@project)
  end

  def edit
  end

  def update
    authorize! :update, @list

    if @list.update(list_params)
      flash[:success] = 'La fase/componente ha sido actualizada exitosamente.'
      redirect_to plan_project_path(@project)
    else
      flash[:danger] = 'Hubo un error al actualizar la fase/componente.'
      render 'edit'
    end
  end

  def destroy
    if @list.destroy
      flash[:success] = 'La fase/componente ha sido eliminada exitosamente.'
    else
      flash[:danger] = 'No se pudo eliminar la fase/componente.'
    end

    redirect_to plan_project_path(@project)
  end

  private

  def list_params
    params.require(:list).permit(:name, :description, :list_type, :project_id)
  end

  def milestone_params
    params.require(:milestone).permit(:name, :end_date)
  end

  def set_list
    @list   = List.find params[:id]
    @project = @list.project
  end

  def set_project
    @project ||= Project.find(params[:project_id])
  end
end

