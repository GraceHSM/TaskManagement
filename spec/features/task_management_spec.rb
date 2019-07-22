require "rails_helper"

RSpec.describe Task, :type => :feature do
  FactoryBot.define do
    factory :task do
      title { Faker::Lorem.sentence }
      content { Faker::Lorem.paragraph }
      start_at { DateTime.new - rand(1..3) }
      deadline_at { DateTime.new + rand(1..3) }
      priority { rand 0..3 }
      status { rand 0..2 }

    end
  end

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
    task = generate_task
    new_task(task)
    expect(page).to have_content('新增成功')
    expect(page).to have_content(task.title)
    expect(page).to have_content(task.content)
    expect(page).to have_content(task.start_at)
    expect(page).to have_content(task.deadline_at)
    expect(page).to have_content(task.priority)
    expect(page).to have_content(task.status)
  end

  it "Edit a task" do
    task = create_task
    new_task = generate_task
    visit edit_task_path(task.id)
    edit_task(task, new_task)
    expect(page).to have_content('修改成功')
    expect(page).to have_content(new_task.title)
    expect(page).to have_content(new_task.content)
    expect(page).to have_content(new_task.start_at)
    expect(page).to have_content(new_task.deadline_at)
    expect(page).to have_content(new_task.priority)
    expect(page).to have_content(new_task.status)
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

  def edit_task(task, new_task)
    fill_in "task_title", :with => new_task.title
    fill_in "task_content", :with => new_task.content
    fill_in "task_start_at", :with => new_task.start_at
    fill_in "task_deadline_at", :with => new_task.deadline_at
    choose (new_task.priority)
    choose (new_task.status)
    click_button "確定"
    task.update(title: new_task.title, content: new_task.content, start_at: new_task.start_at, deadline_at: new_task.deadline_at, priority: new_task.priority, status: new_task.status)
  end

  def generate_task
    build :task
  end

  def create_task
    create :task
  end
end
