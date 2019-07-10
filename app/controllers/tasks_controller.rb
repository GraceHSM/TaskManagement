class TasksController < ApplicationController
  def index
   @tasks = User.find(1).tasks 
  end

  def new
    @task = User.find(1).tasks.new
  end

  def create
    @task = User.find(1).tasks.new(task_params)
    if @task.save
      redirect_to root_path, notice:'新增成功'
    else
      render :new
    end
  end

  def edit
    @task = User.find(1).tasks.find(params[:id])
  end

  def update
    @task = User.find(1).tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to root_path, notice:'修改成功'
    else
      render :edit
    end
  end

  def destroy
    @task = User.find(1).tasks.find(params[:id])
    @task.destroy if @task
    redirect_to root_path, notice:'刪除成功'
  end

  private
  def task_params
    params.require(:task).permit(:title,:content,:priority,:status,:start_at,:deadline_at)
  end
end
