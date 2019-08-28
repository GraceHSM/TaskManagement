class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :task_find, only: [:edit, :show, :show_user_task, :update, :destroy]
  before_action :reorder, only: [:index, :list]
  before_action :current, only: [:show, :show_user_task, :edit]

  def index
    @q = current_user.tasks.includes(:tags, :sort_list).order('sort_lists.sort asc').ransack(params[:q])
    @tags = Tag.all
    @tasks = @q.result.page(params[:page]).per(10)
  end

  def show
  end

  def show_user_task
  end

  def new
    @task = current_user.tasks.new
    @tags = Tag.all
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      @task.create_sort_list(sort: 0)
      if tag_params
        tag_params.each do |tag_id|
          @task.task_tags.create(tag_id: tag_id)
        end
      end
      redirect_to root_path, notice: t('create_success')
    else
      task_save_error
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
      task_save_error
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path, notice: t('delete_success')
  end

  def list
    @tasks = current_user.tasks.includes(:sort_list).order('sort_lists.sort asc')
  end

  def sort
    lists = sort_params
    lists.each_with_index do |list, index|
      item = Task.find(list).sort_list.update(sort: index)
    end
    redirect_to list_tasks_path, notice: t('edit_success')
  end

  private

  def current
    @current_user = current_user
  end

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

  def task_save_error
    @errors = @task.errors.messages
    @checked_tags = tag_params.map do |tag_id|
      Tag.find(tag_id)
    end
    @tags = Tag.all - @checked_tags
  end

  def task_find
    @task = Task.find(params[:id])
  end

  def sort_params
    params[:lists]
  end

  def reorder
    lists = current_user.tasks.includes(:sort_list).order('sort_lists.sort asc').ids
    lists.each_with_index do |list, index|
      item = Task.find(list).sort_list.update(sort: index)
    end
  end
end
