class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :user_find, only: [:edit, :update, :destroy]

  def index
    @users = User.all()
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: t('create_success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: t('edit_success')
    else
      render :edit
    end
  end

  def destroy
    @user.destroy if @user
    redirect_to users_path, notice: t('delete_success')
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def user_find
    @user = User.find(params[:id])
  end
end
