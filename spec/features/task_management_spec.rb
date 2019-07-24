require "rails_helper"

RSpec.describe Task, :type => :feature do
  let(:task){ build :task }

  # task 列表
  it "Display tasks" do
    3.times{
      create_task
    }
    expect(Task.count).to be 3
    visit tasks_path
    expect(page).to have_text(Task.third.title)
  end

  # 依 task 建立日期 created_at 排序
  describe "Display tasks order by created_at" do
    it "created_at ASC" do
      create_task_date('created_at', 3)
      check_page_order('created_at', 'ASC')
    end

    it "created_at DESC" do
      create_task_date('created_at', 3)
      check_page_order('created_at', 'DESC')
    end
  end

  # 新增 task 流程
  it "Create a new task" do
    visit new_task_path
    new_task(task)
    check_page(task, I18n.t('create_success'))
  end

  # 修改 task 流程
  it "Edit a task" do
    old_task = create_task
    visit edit_task_path(old_task.id)
    edit_task(old_task, task)
    check_page(task, I18n.t('edit_success'))
  end

  # 刪除 task 流程
  it "Destroy a task" do
    task = create_task
    visit tasks_path
    expect{ click_on I18n.t('delete') }.to change{ Task.count }.by(-1)
  end

  private
  # 新增 task 欄位
  def new_task(task)
    fill_in "task_title", :with => task.title
    fill_in "task_content", :with => task.content
    fill_in "task_start_at", :with => task.start_at
    fill_in "task_deadline_at", :with => task.deadline_at
    choose ('task_priority_' + task.priority)
    choose ('task_status_' + task.status)
    click_button I18n.t('submit')
    task.save
  end

  # 編輯並更新 task 欄位
  def edit_task(old_task, task)
    fill_in "task_title", :with => task.title
    fill_in "task_content", :with => task.content
    fill_in "task_start_at", :with => task.start_at
    fill_in "task_deadline_at", :with => task.deadline_at
    choose ('task_priority_' + task.priority)
    choose ('task_status_' + task.status)
    click_button I18n.t('submit')
    task.update(title: task.title, content: task.content, start_at: task.start_at, deadline_at: task.deadline_at, priority: task.priority, status: task.status)
  end

  # 產生 task 假資料
  def create_task
    create :task
  end

  # 測試 task 欄位的新增/編輯之後，應出現的資訊
  def check_page(task, message)
    expect(page).to have_content(message)
    expect(page).to have_content(task.title)
    expect(page).to have_content(task.content)
    expect(page).to have_content(task.start_at.to_s(:taskdate))
    expect(page).to have_content(task.deadline_at.to_s(:taskdate))
    expect(page).to have_content(task.priority)
    expect(page).to have_content(task.status)
  end

  # 測試日期欄位排序，產生不同日期順序的資料
  def create_task_date(col, num)
    column = col.to_sym
    num.times{ |n|
      create(:task, column => DateTime.now - n)
    }
    visit tasks_path
  end

  # 測試資料 ASC 與 DESC 排列順序
  def check_page_order(column, order)
    case column
    when 'created_at'
      button = I18n.t('created_sort')
      button = (order = 'ASC') ? button += '+' : button += '-'
    end
    # 後續有其他欄位的排序，再補上 case

    visit tasks_path
    click_on button
    expect(Task.order_by(column, 'ASC').first[column].to_s(:taskdate)).to eq((DateTime.now - 2).to_s(:taskdate))
    expect(Task.order_by(column, 'ASC').last[column].to_s(:taskdate)).to eq((DateTime.now).to_s(:taskdate))
    expect(Task.order_by(column, 'DESC').first[column].to_s(:taskdate)).to eq((DateTime.now).to_s(:taskdate))
    expect(Task.order_by(column, 'DESC').last[column].to_s(:taskdate)).to eq((DateTime.now - 2).to_s(:taskdate))
  end

end
