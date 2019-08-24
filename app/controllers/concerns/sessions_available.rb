module SessionsAvailable
  def authenticate_user!
    if session[:user_id].nil?
      redirect_to login_path, notice: t('please_login')
    end
  end

  def permission_check!
    if not current_user && current_user.role == 'admin'
      redirect_to root_path, notice: t('permission_denied')
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

end