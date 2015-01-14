class MembersController < ApplicationController
  before_filter :set_project

  def create
    params[:users].each do |user|
      @project.project_members.create!(user_id: user[:id], role: user[:role])
    end

    flash[:success] = "Se agregaron #{params[:users].size} usuarios al proyecto exitosamente."
    redirect_to members_project_path(@project)
  end

  def update
    member = @project.project_members.find(params[:id])

    if member.update(role: params[:role])
      response = { member: member.to_json }
    else
      response = { errors: member.errors }
    end

    render json: response
  end

  def destroy
    @member = @project.project_members.find(params[:id])

    if @member.destroy
      flash[:success] = 'El usuario ha sido desvinculado del proyecto exitosamente.'
      redirect_to members_project_path(@project)
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
