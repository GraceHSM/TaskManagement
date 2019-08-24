class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:sign_up, :sign_up_process]
  before_action :permission_check!, except: [:sign_up, :sign_up_process]
  before_action :user_find, only: [:edit, :show, :tasks, :update, :destroy]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def tasks
    @tasks = @user.tasks.includes(:tags).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @user = User.new
  end

  def sign_up
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: t('create_success')
    else
      render :new
    end
  end

  def sign_up_process
    @user = User.new(user_params)

    if @user.save
      log_in @user
      redirect_to tasks_path, notice: t('welcome')
    else
      render :sign_up
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
    if @user.id == current_user.id
      redirect_to users_path, notice: t('you_can_not_delete_yourself')
    else
      if @user.destroy
        redirect_to users_path, notice: t('delete_success')
      else
        redirect_to users_path, notice: t('admin_less_than_1')
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  end

  def user_find
    @user = User.find(params[:id])
  end

  def pwd_digest(pwd)
    Digest::SHA256.hexdigest pwd
  end
end
