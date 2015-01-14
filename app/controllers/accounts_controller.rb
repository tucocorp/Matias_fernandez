class AccountsController < ApplicationController
  before_filter :set_user

  def show
  end

  def update
    attrs  = params.key?(:update_password) ? password_params : update_params
    action = params.key?(:update_password) ? 'update_with_password' : 'update'

    if @user.send(action, attrs)
      flash[:success] = 'Su cuenta ha sido actualizada correctamente'
      sign_in(@user)
      redirect_to account_path
    else
      flash[:danger] = 'No se pudo actualizar su cuenta'
      render 'show'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(
      :name, :last_name, :email,
      :position, :date_of_birth, :address,
      :phone_number, :cell_phone, :avatar
    )
  end
end
