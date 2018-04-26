class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def after_inactive_sign_up_path_for(resource)
    edit_user_path(resource)
  end

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => %i[role user_name time_zone])
    devise_parameter_sanitizer.permit(:account_update, :keys => %i[role user_name time_zone])
  end
end
