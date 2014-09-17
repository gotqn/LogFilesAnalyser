class ApplicationController < ActionController::Base

  helper_method :get_user_name_by_id, :get_log_files_by_id, :get_access_type_id_by_name

  rescue_from CanCan::AccessDenied do |exception|

    if exception.action == :show and exception.subject.class.name == 'DemoGem'
      redirect_to new_session_path(User.new)
    else
      render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller? or :omniauth_callbacks_controller?

  def get_user_name_by_id(user_id)
    if user_id.nil? or user_id.blank?
      'User was deleted'
    else
      if User.exists?(id: user_id)
        User.find(user_id).login
      else
        'User was deleted'
      end
    end
  end

  def get_log_files_by_id(user_id)
    if LogFile.exists?(user_id: user_id)
      LogFile.where(user_id: user_id)
    else
      []
    end
  end

  def get_access_type_id_by_name (name)
    AccessType.find_by_name(name).id
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :encrypted_password) }
    end

end
