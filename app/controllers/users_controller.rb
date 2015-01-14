class UsersController < ApplicationController
  before_filter :set_user, only: [:lock, :unlock, :edit, :update, :add_to_project, :add_to_company]

  def index
    if @user = User.where(email: params[:email]).first
      if !params[:company_id].blank?
        @company = Company.find(params[:company_id])
        in_company = @company.members.exists?(id: @user)
        render json: @user, root: :user, meta: { in_company: in_company }

      elsif !params[:project_id].blank?
        @project = Project.find(params[:project_id])
        in_project = @project.members.exists?(id: @user)
        render json: @user, root: :user, meta: { in_project: in_project }
      end
    else
      @user = User.all
      render json: @user
    end
  end

  def show
    render json: @user
  end
  
  def new
    @user = User.new
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @company = Company.find(params[:company_id]) unless params[:company_id].blank?
  end

  def create
    @user = User.new(user_params)
    @project = Project.find(params[:user][:project_id]) unless params[:user][:project_id].blank?
    @company = Company.find(params[:user][:company_id]) unless params[:user][:company_id].blank?

    respond_to do |format|
      format.html do 
        if @user.save
          flash[:success] = 'Usuario creado exitosamente'
          if !@project.nil?
            @project.project_members.create(user: @user, role: "member")
            redirect_to project_members_path(@project)
          elsif !@company.nil?
            @company.company_members.create(user: @user, role: "member")
            redirect_to users_company_path(@company)
          else
            redirect_to users_path
          end
        else
          flash[:danger] = 'No se pudo crear el usuario'
          render 'new'
        end
      end 
      format.json do
        if @user.save
           render json: @user 
        end
      end
    end
  end

  def edit
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @company = Company.find(params[:company_id]) unless params[:company_id].blank?
  end

  def update
    options = params.key?(:update_password) ? password_params : user_params
    @project = Project.find(params[:user][:project_id]) unless params[:user][:project_id].blank?
    @company = Company.find(params[:user][:company_id]) unless params[:user][:company_id].blank?

    if @user.update_attributes(options)
      flash[:success] = 'Usuario actualizado exitosamente.'
      if !@project.nil?
        redirect_to project_members_path(@project)
      elsif !@company.nil?
        redirect_to users_company_path(@company)
      else
        redirect_to users_path
      end
    else
      flash[:danger] = 'No se pudo actualizar el usuario.'
      render 'edit'
    end
  end

  def lock
    if current_user == @user
      flash[:danger] = 'No puedes bloquear tu cuenta.'
      redirect_to(users_path) and return
    end

    if @user.lock_access!(send_instructions: false)
      flash[:success] = 'Usuario bloqueado exitosamente.'
    else
      flash[:danger] = 'No se pudo bloquear el usuario.'
    end

    redirect_to users_path
  end

  def unlock
    if @user.unlock_access!
      flash[:success] = 'Usuario habilitado exitosamente.'
    else
      flash[:danger] = 'No se pudo habilitar el usuario.'
    end

    redirect_to users_path
  end

  def add_to_project
    @project = Project.find(params[:project_id])
    if @project.is_member?(@user)
      flash[:danger] = 'El usuario ya es un miembro de este proyecto.'
    else
      if @project.project_members.create(user: @user, role: "collaborator")
        # UserMailer.add_member(@user, @project).deliver
        flash[:success] = 'Se ha agregado un usuario al proyecto exitosamente.'    
      else
        flash[:danger] = 'No se pudo agregar un usuario al projecto.'
      end
    end
    redirect_to members_project_path(@project)
  end

  def invite_to_project
    @project  = Project.find(params[:project_id])
    @user     = User.invite!(email: params[:email])
    @project.project_members.create(user: @user, role: 'collaborator')

    flash[:success] = "Se ha enviado la invitación a #{@email} exitosamente."
    redirect_to members_project_path(@project)
  end

  def add_to_company
    @company = Company.find(params[:company_id])
    if @company.is_member?(@user)
      flash[:danger] = 'El usuario ya es un miembro de esta compañia.'
    else
      if @company.company_members.create(user: @user, role: 'collaborator')
        # UserMailer.add_member(@user, @project).deliver
        flash[:success] = 'Se ha agregado un usuario a la compañia exitosamente.'    
      else
        flash[:danger] = 'No se pudo agregar un usuario a la compañia.'
      end  
    end
    redirect_to members_company_path(@company)
  end

  def invite_to_company
    # abort(YAML::dump(params))
    @company  = Company.find(params[:company_id])
    @user     = User.invite!(email: params[:email])
    
    @company.company_members.create(user: @user, role: 'collaborator')

    flash[:success] = "Se ha enviado la invitación a #{@email} exitosamente."
    redirect_to members_company_path(@company)
  end

  private

  def set_user
    @user = User.find(params[:user_id] || params[:id])
  end

  def user_params
    params.require(:user).permit(
      :username, :name, :last_name, :email,
      :position, :date_of_birth, :address,
      :phone_number, :cell_phone,
      :password, :password_confirmation, :avatar
    )
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(
      :username, :name, :last_name, :email,
      :position, :date_of_birth, :address,
      :phone_number, :cell_phone, :avatar
    )
  end

end
