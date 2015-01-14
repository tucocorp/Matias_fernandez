class CompaniesController < ApplicationController
  before_filter :set_company, except: [:index, :new, :create]

  def index
    companies = Company.search(
      name_or_initials_or_email_or_contact_name_cont: params[:q].to_s
    ).result

    companies  = companies.joins(:company_members).where('company_members.user_id = ?', current_user.id)
    @companies = companies.page(params[:page]).per(10)
  end

  def show
    redirect_to projects_company_path(@company)
  end

  def projects
    @companies = current_user.my_companies
    projects = @company.projects.search(
      name_or_code_or_status_cont: params[:q].to_s
    ).result

    @projects = projects.page(params[:page]).per(10)
  end

  def members
    users = @company.company_members.includes(:user).search(
      user_username_or_user_name_or_user_last_name_or_user_email_cont: params[:q].to_s
    ).result
    @users = users.page(params[:page]).per(10)
    @roles   = CompanyMember.roles.reject { |r| r.id == :owner }
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.company_members.new(user: current_user, role: "pmo")

    if @company.save
      flash[:success] = "La compañia #{@company.name} ha sido creada exitosamente."
      redirect_to companies_path
    else
      flash[:danger] = "No se pudo crear la compañia solicitada."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      flash[:success] = "La compañia #{@company.name} ha sido editada exitosamente."
      redirect_to edit_company_path(@company)
    else
      flash[:danger] = "No se pudo editar la compañia #{@company.name}."
      render 'edit'
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name, :initials, :description, :contact_name,
      :phone_number, :email, :status, :rut, :business_name,
      :website
    )
  end

  def set_company
    @company = Company.find params[:id]
  end
end
