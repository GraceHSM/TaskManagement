require "rails_helper"

RSpec.describe Task, :type => :feature do
  let(:title) {Faker::Lorem.sentence}
  let(:content) {Faker::Lorem.paragraph}
  let(:new_title) {Faker::Lorem.sentence}
  let(:new_content) {Faker::Lorem.paragraph}

  it "Display tasks" do
    3.times{
      Task.create(title: title, content: content)
    }
    expect(Task.count).to be 3
    visit tasks_path
    expect(page).to have_text(Task.third.title)
  end

  it "Create a new task" do
    visit new_task_path
    create_task(title, content)
    expect(page).to have_content(title)
    expect(page).to have_content(content)
  end

  it "Edit a task" do
    task = Task.create(title: title, content: content)
    visit edit_task_path(task.id)
    create_task(new_title, new_content)
    expect(page).to have_content(new_title)
    expect(page).to have_content(new_content)
  end

  it "Destroy a task" do
    task = Task.create(title: title, content: content)
    visit tasks_path
    expect{ click_on "Delete"}.to change{ Task.count }.by(-1)
  end

  private
  def create_task(title, content)
    fill_in "task_title", :with => title
    fill_in "task_content", :with => content
    choose('pending')
    choose('secondly')
    click_button "確定"
  end
end
