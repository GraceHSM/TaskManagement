class SessionsController < ApplicationController
before_action :authenticate_user!, only: [:destroy]
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user and (user.password == params[:password])
      log_in user
      redirect_to root_path
    else
      redirect_to login_path, notice: t('please_login_again')
    end
  end

  def destroy
    session.clear
    redirect_to login_path, notice: t('signout')
  end
end
