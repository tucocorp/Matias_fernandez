class IssuesController < ApplicationController
  before_action :set_data

  def create
    @issue = @activity.issues.new(issue_params)

    if @issue.save
      flash[:success] = 'Causa de no cumplimiento ingresada exitosamente'
      @activity.unfinished!
    else
      flash[:danger] = 'Hubo un error al actualizar la actividad'
    end

    redirect_to last_planner_project_path(@activity.project)
  end

  private

  def issue_params
    params.require(:issue).permit(:activity_id, :name, constraint_ids: [])
  end

  def set_data
    @activity = Activity.find(issue_params[:activity_id])

    authorize! :update, @activity
  end
end
