class ApplicationController < ActionController::Base 
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :apellido, :dni, :rol, :fecha_nacimiento])
        devise_parameter_sanitizer.permit(:account_update, keys: [:nombre, :apellido, :dni, :rol, :fecha_nacimiento])
    end
end