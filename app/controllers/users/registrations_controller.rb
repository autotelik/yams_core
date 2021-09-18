# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  #include PunditHelper

  def show
    @user = User.find(params[:id])
    authorize @user
    render :show
  end

  def sign_up_params
    params.require(:user).permit(:avatar, :name, :email, :password, :password_confirmation, :tag_list)
  end

  def account_update_params
    params.require(:user).permit(:avatar, :current_password, :name, :email, :name, :bio, :firstname, :lastname, :city, :country, :password, :password_confirmation, :tag_list)
  end

  private

  # PUT /resource
  # for now we wont require current password on any change including password change
  # Devise default is to require a password checks on any update.

  def update_resource(resource, params)
    # if params['email'] != current_user.email || params['password'].present?
    #  resource.update_with_password(params)
    # else
    resource.update_without_password(params.except('password', 'password_confirmation', 'current_password'))
    # end
  end


  # The default url to be used after updating a resource.
  #
  def after_update_path_for(resource)
    # sign_in_after_change_password? ? signed_in_root_path(resource) : new_session_path(resource_name) )
    yams_core.edit_user_registration_path(resource)
  end

end

