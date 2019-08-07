module SessionsHelper
  def authenticate_user!
    if session[:user_id].nil?
      redirect_to login_path, notice: 'Please Login'
    end
  end

  def permission_check!
    if not is_admin?
      redirect_to root_path, notice: 'Permission denied'
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def is_admin?
    current_user.role == 'admin'
  end
end
