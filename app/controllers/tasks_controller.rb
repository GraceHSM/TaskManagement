class TasksController < ApplicationController
  before_action :task_find, :only => [:edit, :update, :destroy]

  def index
   @tasks = Task.order('id ASC')
   # 日後加上分頁功能再將all改掉
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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


  def sort
    col = params[:col]
    order = params[:order]
    @tasks = Task.order_by(col,order)
    render :index
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :priority, :status, :start_at, :deadline_at)
  end

  def task_find
    @task = Task.find(params[:id])
  end
end
