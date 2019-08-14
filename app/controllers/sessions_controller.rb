class SessionsController < ApplicationController
before_action :authenticate_user!, only: [:destroy]
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && (user.password == pwd_digest(params[:password]))
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

  private
  def pwd_digest(pwd)
    Digest::SHA256.hexdigest pwd
  end
end
