require "rails_helper"

RSpec.describe Task, :type => :feature do
  let(:task){ build :task }

  it "Display tasks" do
    3.times{
      create_task
    }
    expect(Task.count).to be 3
    visit tasks_path
    expect(page).to have_text(Task.third.title)
  end

  it "Create a new task" do
    visit new_task_path
    new_task(task)
    check_page(task, '新增成功')
  end

  it "Edit a task" do
    old_task = create_task
    visit edit_task_path(old_task.id)
    edit_task(old_task, task)
    check_page(task, '修改成功')
  end

  it "Destroy a task" do
    task = create_task
    visit tasks_path
    expect{ click_on "Delete" }.to change{ Task.count }.by(-1)
  end

  private
  def new_task(task)
    fill_in "task_title", :with => task.title
    fill_in "task_content", :with => task.content
    fill_in "task_start_at", :with => task.start_at
    fill_in "task_deadline_at", :with => task.deadline_at
    choose (task.priority)
    choose (task.status)
    click_button "確定"
    task.save
  end

  def edit_task(old_task, task)
    fill_in "task_title", :with => task.title
    fill_in "task_content", :with => task.content
    fill_in "task_start_at", :with => task.start_at
    fill_in "task_deadline_at", :with => task.deadline_at
    choose (task.priority)
    choose (task.status)
    click_button "確定"
    task.update(title: task.title, content: task.content, start_at: task.start_at, deadline_at: task.deadline_at, priority: task.priority, status: task.status)
  end

  def create_task
    create :task
  end

  def check_page(task, message)
    expect(page).to have_content(message)
    expect(page).to have_content(task.title)
    expect(page).to have_content(task.content)
    expect(page).to have_content(task.start_at)
    expect(page).to have_content(task.deadline_at)
    expect(page).to have_content(task.priority)
    expect(page).to have_content(task.status)
  end
end
