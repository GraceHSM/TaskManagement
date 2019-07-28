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
    it "ASC" do
      create_task_date('created_at', 2)
      click_on I18n.t('created_at_asc')
      check_page_sorted('created_at_asc')
    end

    it "DESC" do
      create_task_date('created_at', 2)
      click_on I18n.t('created_at_desc')
      check_page_sorted('created_at_desc')
    end
  end

  # 依 task 結束日期 start_at 排序
  describe "Display tasks order by start_at" do
    it "ASC" do
      create_task_date('start_at', 2)
      click_on I18n.t('start_at_asc')
      check_page_sorted('start_at_asc')
    end

    it "DESC" do
      create_task_date('start_at', 2)
      click_on I18n.t('start_at_desc')
      check_page_sorted('start_at_desc')
    end
  end

  # 依 task 結束日期 deadline_at 排序
  describe "Display tasks order by deadline_at" do
    it "ASC" do
      create_task_date('deadline_at', 2)
      click_on I18n.t('deadline_at_asc')
      check_page_sorted('deadline_at_asc')
    end

    it "DESC" do
      create_task_date('deadline_at', 2)
      click_on I18n.t('deadline_at_desc')
      check_page_sorted('deadline_at_desc')
    end
  end

  # 新增 task 流程
  it "Create a new task" do
    visit new_task_path
    new_task(task)
    check_page(task, I18n.t('create_success'))
  end

  # 新增 task 欄位驗證
  describe "Validate create new task" do
    it "validate title column" do
      visit new_task_path
      new_valid_task(task,'title')
      expect(page).to have_content(I18n.t('must_be_presence'))
    end

    it "validate content column" do
      visit new_task_path
      new_valid_task(task,'content')
      expect(page).to have_content(I18n.t('must_be_presence'))
    end

    it "validate start_at column" do
      visit new_task_path
      new_valid_task(task,'start_at')
      expect(page).to have_content(I18n.t('must_be_choose_date'))
    end

    it "validate deadline_at column" do
      visit new_task_path
      new_valid_task(task,'deadline_at')
      expect(page).to have_content(I18n.t('must_be_choose_date'))
    end

    it "validate priority column" do
      visit new_task_path
      new_valid_task(task,'priority')
      expect(page).to have_content(I18n.t('must_be_choose_option'))
    end

    it "validate status column" do
      visit new_task_path
      new_valid_task(task,'priority')
      expect(page).to have_content(I18n.t('must_be_choose_option'))
    end

    it "validate start_at_cannot_greater_than_deadline" do
      visit new_task_path
      new_valid_task(task,'date_valid')
      expect(page).to have_content(I18n.t('start_at_cannot_greater_than_deadline'))
    end
  end

  # 修改 task 流程
  it "Edit a task" do
    old_task = create_task
    visit edit_task_path(old_task.id)
    edit_task(old_task, task)
    check_page(old_task, I18n.t('edit_success'))
  end

  # 刪除 task 流程
  it "Destroy a task" do
    task = create_task
    visit tasks_path
    expect{ click_on I18n.t('delete') }.to change{ Task.count }.by(-1)
  end

  private
  # 新增 task 欄位
  def new_task_column(task)
    fill_in "task_title", :with => task.title
    fill_in "task_content", :with => task.content
    fill_in "task_start_at", :with => task.start_at
    fill_in "task_deadline_at", :with => task.deadline_at
  end

  # 新增 task
  def new_task(task)
    new_task_column(task)
    choose ('task_priority_' + task.priority)
    choose ('task_status_' + task.status)
    click_button I18n.t('submit')
    task.save
  end

  def new_valid_task(task,column)
    new_task_column(task)
    case column
    when 'title'
      fill_in "task_title", :with => ''
      choose ('task_priority_' + task.priority)
      choose ('task_status_' + task.status)
    when 'content'
      fill_in "task_content", :with => ''
      choose ('task_priority_' + task.priority)
      choose ('task_status_' + task.status)
    when 'start_at'
      fill_in "task_start_at", :with => ''
      choose ('task_priority_' + task.priority)
      choose ('task_status_' + task.status)
    when 'deadline_at'
      fill_in "task_deadline_at", :with => ''
      choose ('task_priority_' + task.priority)
      choose ('task_status_' + task.status)
    when 'priority'
      choose ('task_status_' + task.status)
    when 'status'
      choose ('task_priority_' + task.priority)
    when 'date_valid'
      fill_in "task_start_at", :with => DateTime.now
      fill_in "task_deadline_at", :with => (DateTime.now - 1)
      choose ('task_priority_' + task.priority)
      choose ('task_status_' + task.status)
    end
    click_button I18n.t('submit')
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
    old_task.update(title: task.title, content: task.content, start_at: task.start_at, deadline_at: task.deadline_at, priority: task.priority, status: task.status)
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
      create(:task, column => (DateTime.now - n))
    }
    visit tasks_path
  end

  # 測試資料 ASC 與 DESC 排列順序
  def check_page_sorted(button)
    case button
    when 'created_at_asc'
      expect(first('.card').find('.created_at')).to have_text((DateTime.now - 1).to_s(:taskdate))

      expect(first('.card').find('.created_at')).to have_text(Task.sorted_by(button).first['created_at'].to_s(:taskdate))

    when 'created_at_desc'
      expect(first('.card').find('.created_at')).to have_text((DateTime.now).to_s(:taskdate))

      expect(first('.card').find('.created_at')).to have_text(Task.sorted_by(button).first['created_at'].to_s(:taskdate))

    when 'start_at_asc'
      expect(first('.card').find('.start_at')).to have_text((DateTime.now - 1).to_s(:taskdate))

      expect(first('.card').find('.start_at')).to have_text(Task.sorted_by(button).first['start_at'].to_s(:taskdate))

    when 'start_at_desc'
      expect(first('.card').find('.start_at')).to have_text((DateTime.now).to_s(:taskdate))

      expect(first('.card').find('.start_at')).to have_text(Task.sorted_by(button).first['start_at'].to_s(:taskdate))

    when 'deadline_at_asc'
      expect(first('.card').find('.deadline_at')).to have_text((DateTime.now - 1).to_s(:taskdate))

      expect(first('.card').find('.deadline_at')).to have_text(Task.sorted_by(button).first['deadline_at'].to_s(:taskdate))

    when 'deadline_at_desc'
      expect(first('.card').find('.deadline_at')).to have_text((DateTime.now).to_s(:taskdate))

      expect(first('.card').find('.deadline_at')).to have_text(Task.sorted_by(button).first['deadline_at'].to_s(:taskdate))
    end
  end
end
