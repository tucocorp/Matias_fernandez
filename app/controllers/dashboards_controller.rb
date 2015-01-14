class DashboardsController < ApplicationController

  def index
    @projects    = Project.accessible_by(current_ability, :read).active.limit(5)
    @activities  = current_user.activities.nearest.upcoming.limit(10)
    @constraints = current_user.constraints.includes(:activity).nearest.upcoming.limit(10)
    @meetings    = current_user.meetings.includes(:project).nearest.upcoming.limit(5)

    @companies = current_user.my_companies
  end
end
