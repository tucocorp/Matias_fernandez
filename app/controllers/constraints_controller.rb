class ConstraintsController < ApplicationController

  def show
    @constraint = Constraint.find(params[:id])
    # authorize! :read, @constraint

    render json: @constraint, serializer: FullConstraintSerializer
  end

  def create
    if params[:meeting_id].present?
      @meeting    = Meeting.find(params[:meeting_id])
      @activity   = Activity.find(constraint_params[:activity_id])
    else
      @activity   = Activity.find(constraint_params[:activity_id])
    end

    @constraint = @activity.constraints.new(constraint_params)

    respond_to do |format|
      if @constraint.save
        format.html { redirect_to(meeting_path(@meeting)) }
        format.json { render json: @constraint }
      else
        format.html { redirect_to(meeting_path(@meeting)) }
        format.json { render json: { errors: @constraint.errors } }
      end
    end

    # respond_to do |format|
    #   if @constraint.save
    #     format.html do
    #       flash[:success] = 'Restricción creada exitosamente'
    #       if params[:meeting_id].present?
    #         redirect_to activities_meeting_path(@meeting)
    #       else
    #         redirect_to last_planner_project_path(@activity.project)
    #       end
    #     end

    #     format.json do
    #       render json: @constraint 
    #     end
    #   else
    #     format.html do
    #       flash[:danger] = 'Hubo un error al crear la restricción'
    #       if params[:meeting_id].present?
    #         redirect_to activities_meeting_path(@meeting)
    #       else
    #         redirect_to last_planner_project_path(@activity.project)
    #       end
    #     end

    #     format.json do
    #       render json: { errors: @constraint }
    #     end
    #   end
    # end

  end

  def update
    @constraint = Constraint.find(params[:id])

    if @constraint.update(constraint_params)
      render json: @constraint
    else
      render json: { errors: @constraint.errors }
    end
  end

  def destroy
    @constraint = Constraint.find(params[:id])

    respond_to do |format|
      if @constraint.destroy
        format.html {
          flash[:success] = 'Restricción eliminada correctamente'
          redirect_to last_planner_project_path(@constraint.activity.project)
        }
        format.json { render json: {} }
      else
        format.html {
          flash[:danger] = 'Hubo un error al eliminar la restricción'
          redirect_to last_planner_project_path(@constraint.activity.project)
        }
        format.json { render json: { errors: ['Hubo un error al eliminar la restricción'] } }
      end
    end
  end

  private

  def constraint_params
    params.require(:constraint).permit(
      :name, :activity_id, :end_date, :category_id, :assigned_id, :status
    )
  end
end
