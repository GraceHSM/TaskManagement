class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :permission_check!
  before_action :user_find, only: [:edit, :show, :update, :destroy]

  def index
    @users = User.page(params[:page]).per(5)
  end

  def show
    @tasks = @user.tasks.page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if current_user.role == 'member'
        redirect_to root_path, notice: t('create_success')
      else
        redirect_to users_path, notice: t('create_success')
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      if is_admin?
        redirect_to users_path, notice: t('edit_success')
      else
        redirect_to tasks_path, notice: t('edit_success')
      end
    else
      render :edit
    end
  end

  def destroy
    if @user.role == 'admin'
      if User.where(role: 'admin').count > 1
        @user.destroy if @user
        redirect_to users_path, notice: t('delete_success')
      elsif is_admin?
        redirect_to users_path, notice: 'you can not delete yourself'
      else
        redirect_to users_path, notice: 'admin less than 1'
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :role)
  end

  def user_find
    @user = User.find(params[:id])
  end
end
