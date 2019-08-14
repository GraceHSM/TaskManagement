class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :task_find, only: [:edit, :show, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result.page(params[:page]).per(5)
  end

  def show
  end

  def new
    @task = Task.new
    @tags = Tag.all
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      if tag_params
        tag_params.each do |tag_id|
          @task.task_tags.create(tag_id: tag_id)
        end
      end
      redirect_to root_path, notice: t('create_success')
    else
      render :new
    end
  end

  def edit
    @checked_tags = @task.tags
    @tags = Tag.all - @checked_tags
  end

  def update
    if @task.update(task_params)
      if tag_params
        unchecked = @task.tags.ids - tag_params
        unchecked.each do |tag_id|
          @task.task_tags.find_by(tag_id: tag_id).delete
        end
        checked = tag_params - @task.tags.ids
        checked.each do |tag_id|
          @task.task_tags.create(tag_id: tag_id)
        end
      end
      redirect_to root_path, notice: t('edit_success')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path, notice: t('delete_success')
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :priority, :status, :start_at, :deadline_at)
  end

  def tag_params
    if params[:tag_ids]
      return params.require(:tag_ids)
    else
      return []
    end
  end

  def task_find
    @task = Task.find(params[:id])
  end
end
