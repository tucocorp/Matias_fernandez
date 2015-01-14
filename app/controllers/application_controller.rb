class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { errors: {permissions: exception.message} } }
      format.html { 
        flash[:danger] = exception.message
        redirect_to(root_url) 
      }
    end
  end

  def current_member
    return nil if @project.nil?
    @project.project_members.where(user: current_user).first
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login, :email, :password, :remember_me)
    end

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :name, :last_name ,:email, :password, :password_confirmation)
    end
  end

  def authenticate_user_from_token!
    user_email = params[:email].presence
    user       = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.access_token, params[:access_token].to_s)
      sign_in(user)
    end
  end
end
