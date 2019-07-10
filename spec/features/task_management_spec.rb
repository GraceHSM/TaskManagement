require "rails_helper"

RSpec.describe "Task management" do
  it "Creates a new task" do
    visit "/tasks/new"

    fill_in "task_title", :with => "My Task"
    fill_in "task_content", :with => "My Task Content"
    click_button "確定"
    expect(page).to have_text("新增成功")




    # rspec spec/features/task_management_spec.rb
  end
end