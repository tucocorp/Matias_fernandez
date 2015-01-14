class UnitWorksController < ApplicationController
  before_action :set_unit_work, only: [:show, :edit, :update, :destroy]

  def index
    @unit_works = UnitWork.all
  end

  def show
  end

  def new
    @unit_work = UnitWork.new
  end

  def edit
  end

 def create
    @unit_work = UnitWork.new(unit_work_params)

    respond_to do |format|
      if @unit_work.save
      	flash[:success] = 'Se ha creado una unidad de trabajo exitosamente.'
        redirect_to @unit_work
      else
        flash[:danger] = 'Hubo un error al crear una unidad de trabajo.'
        render 'new'
	  end
    end
  end

  def update
    respond_to do |format|
      if @unit_work.update(unit_work_params)
        flash[:success] = 'La unidad de trabajo ha sido actualizada exitosamente.'
        redirect_to @unit_work
      else
        flash[:danger] = 'Hubo un error al actualizar la unidad de trabajo.'
        render 'edit'
      end
    end
  end

  def destroy
    if @unit_work.destroy
		flash[:success] = 'La unidad de trabajo ha sido actualizada exitosamente.'
    else   
    	flash[:danger] = 'Hubo un error al eliminar la unidad de trabajo.'
    end
    redirect_to @unit_work
  end

  private
    def set_unit_work
      @unit_work = UnitWork.find(params[:id])
    end

    def unit_work_params
      params.require(:unit_work).permit(:start_date, :end_date, :activity_id)
    end
end

