class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
      	flash[:success] = 'Se ha creado una tarea exitosamente.'
        redirect_to @task
      else
      	flash[:danger] = 'Hubo un error al crear una tarea.'
        render 'new'
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
      	flash[:success] = 'La tarea ha sido actualizada exitosamente.'
        redirect_to @task
      else
       flash[:danger] = 'Hubo un error al actualizar la tarea.'
       render 'edit'
      end
    end
  end

  def destroy
    if @task.destroy
  		flash[:success] = 'La tarea ha sido eliminada exitosamente.'
    else
    	flash[:danger] = 'Hubo un error al eliminar la tarea.'
    end
  	redirect_to @task
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:code, :name, :description, :start_date, :end_date, :assigned_id, :activity_id)
    end
end
