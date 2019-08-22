module SessionsHelper
  def logged_in?
    @current_user.present?
  end

  def is_admin?(current_user)
    true if current_user && current_user.role == 'admin'
  end
end
