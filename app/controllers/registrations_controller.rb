class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    flash[:notice] = "Your account has been submitted for approval."
    new_user_session_path
  end
end