class TasksController < ApplicationController
  before_action :task_find, only: [:edit, :update, :destroy]

  def index
    current_user = User.last
    sort
  end


  def new
    @task = Task.new
  end

  def create
    current_user = User.last
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to root_path, notice: t('create_success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to root_path, notice: t('edit_success')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy if @task
    redirect_to root_path, notice: t('delete_success')
  end

  private

  def sort
    @q = Task.ransack(params[:q])
    @tasks = @q.result.page(params[:page]).per(5)
  end

  def task_params
    params.require(:task).permit(:title, :content, :priority, :status, :start_at, :deadline_at)
  end

  def task_find
    @task = Task.find(params[:id])
  end
end
