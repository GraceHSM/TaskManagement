class TasksController < ApplicationController
  before_action :task_find, :only => [:edit, :update, :destroy]

  def index
    sort
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

  private

  def sort
    @q = Task.ransack(title_cont: params[:title], status_eq: params[:status])
    query = @q.result
    @tasks = query.sorted_by(params[:sort])

    # @tasks = Task.sorted_by(params[:sort])
  end

  def task_params
    params.require(:task).permit(:title, :content, :priority, :status, :start_at, :deadline_at)
  end

  def task_find
    @task = Task.find(params[:id])
  end
end
