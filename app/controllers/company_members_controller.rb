class CompanyMembersController < ApplicationController
  before_filter :set_company

  def create
    params[:users].each do |user|
      @company.company_members.create!(user_id: user[:id], role: user[:role])
    end

    flash[:success] = "Se agregaron #{params[:users].size} usuarios al proyecto exitosamente."
    redirect_to members_company_path(@company)
  end

  def update
    member = @company.company_members.find(params[:id])

    if member.update(role: params[:role])
      response = { member: member.to_json }
    else
      response = { errors: member.errors }
    end

    render json: response
  end

  def destroy
    @member = @company.company_members.find(params[:id])
    member = @member

    if @member.destroy
      flash[:success] = "El usuario #{member.full_name} ha sido desvinculado del la compañia exitosamente."
      redirect_to members_company_path(@company)
    end
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end
