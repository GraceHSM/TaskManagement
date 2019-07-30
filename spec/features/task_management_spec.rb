require "rails_helper"

RSpec.describe Task, :type => :feature do
  let(:task){ create(:task) }
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }
  let(:start_at) { DateTime.now - 1 }
  let(:deadline_at) { DateTime.now + 1 }
  let(:priority) { ['primary', 'secondly', 'common'].sample }
  let(:status) { ['pending', 'processing', 'completed'].sample }

  # task 列表
  it "Display tasks" do
    3.times{
      create(:task)
    }
    expect(Task.count).to be 3
    visit tasks_path
    expect(page).to have_text(Task.third.title)
  end

  # 依 task 建立日期 created_at 排序
  describe "Display tasks order by created_at" do
    it "ASC" do
      create_sorted_date('created_at')
      click_on I18n.t('created_at_asc')
      check_page_sorted('created_at_asc')
    end

    it "DESC" do
      create_sorted_date('created_at')
      click_on I18n.t('created_at_desc')
      check_page_sorted('created_at_desc')
    end
  end

  # 依 task 結束日期 start_at 排序
  describe "Display tasks order by start_at" do
    it "ASC" do
      create_sorted_date('start_at')
      click_on I18n.t('start_at_asc')
      check_page_sorted('start_at_asc')
    end

    it "DESC" do
      create_sorted_date('start_at')
      click_on I18n.t('start_at_desc')
      check_page_sorted('start_at_desc')
    end
  end

  # 依 task 結束日期 deadline_at 排序
  describe "Display tasks order by deadline_at" do
    it "ASC" do
      create_sorted_date('deadline_at')
      click_on I18n.t('deadline_at_asc')
      check_page_sorted('deadline_at_asc')
    end

    it "DESC" do
      create_sorted_date('deadline_at')
      click_on I18n.t('deadline_at_desc')
      check_page_sorted('deadline_at_desc')
    end
  end

  # 新增 task 流程
  it "Fill in a new task" do
    fill_in_new_task('all')
    check_page(I18n.t('create_success'))
  end

  # 新增 task 欄位驗證
  describe "Validate fill in new task" do
    it "validate title must be presence" do
      fill_in_new_task('without_title')
      expect(page).to have_content(I18n.t('must_be_presence'))
    end

    it "validate content must be presence" do
      fill_in_new_task('without_content')
      expect(page).to have_content(I18n.t('must_be_presence'))
    end

    it "validate start_at default value" do
      fill_in_new_task('default_start_at')
      expect(page).to have_content(I18n.t('create_success'))
      expect(find('.start_at')).to have_content(DateTime.now.to_s(:taskdate))
    end

    it "validate deadline_at default value" do
      fill_in_new_task('default_deadline_at')
      expect(page).to have_content(I18n.t('create_success'))
      expect(find('.deadline_at')).to have_content(DateTime.now.to_s(:taskdate))
    end

    it "validate priority default value" do
      fill_in_new_task('default_priority')
      expect(page).to have_content(I18n.t('create_success'))
      expect(find('.priority')).to have_content('common')
    end

    it "validate status default value" do
      fill_in_new_task('default_status')
      expect(page).to have_content(I18n.t('create_success'))
      expect(find('.status')).to have_content('pending')
    end

    it "validate start_at_cannot_greater_than_deadline" do
      fill_in_new_task('start_greater_than_deadline')
      expect(page).to have_content(I18n.t('start_at_cannot_greater_than_deadline'))
    end
  end

  # 修改 task 流程
  it "Edit a task" do
    old_task = task
    visit edit_task_path(old_task.id)
    edit_task(old_task)
    check_page(I18n.t('edit_success'))
  end

  # 刪除 task 流程
  it "Destroy a task" do
    task
    visit tasks_path
    expect{ click_on I18n.t('delete') }.to change{ Task.count }.by(-1)
  end

  private
  # Fill in new task
  def fill_in_new_task(condition)
    visit new_task_path
    case condition
    when 'all'
      fill_in 'task_title', :with => title
      fill_in 'task_content', :with => content
      fill_in 'task_start_at', :with => start_at
      fill_in 'task_deadline_at', :with => deadline_at
      choose ('task_priority_' + priority)
      choose ('task_status_' + status)
    when 'without_title'
      fill_in 'task_content', :with => content
      fill_in 'task_start_at', :with => start_at
      fill_in 'task_deadline_at', :with => deadline_at
      choose ('task_priority_' + priority)
      choose ('task_status_' + status)
    when 'without_content'
      fill_in 'task_title', :with => title
      fill_in 'task_start_at', :with => start_at
      fill_in 'task_deadline_at', :with => deadline_at
      choose ('task_priority_' + priority)
      choose ('task_status_' + status)
    when 'default_start_at'
      fill_in 'task_title', :with => title
      fill_in 'task_content', :with => content
      fill_in 'task_deadline_at', :with => deadline_at
      choose ('task_priority_' + priority)
      choose ('task_status_' + status)
    when 'default_deadline_at'
      fill_in 'task_title', :with => title
      fill_in 'task_content', :with => content
      fill_in 'task_start_at', :with => start_at
      choose ('task_priority_' + priority)
      choose ('task_status_' + status)
    when 'default_priority'
      fill_in 'task_title', :with => title
      fill_in 'task_content', :with => content
      fill_in 'task_start_at', :with => start_at
      fill_in 'task_deadline_at', :with => deadline_at
      choose ('task_status_' + status)
    when 'default_status'
      fill_in 'task_title', :with => title
      fill_in 'task_content', :with => content
      fill_in 'task_start_at', :with => start_at
      fill_in 'task_deadline_at', :with => deadline_at
      choose ('task_priority_' + priority)
    when 'start_greater_than_deadline'
      fill_in 'task_title', :with => title
      fill_in 'task_content', :with => content
      fill_in 'task_start_at', :with => DateTime.now + 1
      fill_in 'task_deadline_at', :with => DateTime.now - 1
      choose ('task_priority_' + priority)
      choose ('task_status_' + status)
    end
    click_button I18n.t('submit')
    task.save
  end

  # 編輯並更新 task 欄位
  def edit_task(old_task)
    fill_in "task_title", :with => title
    fill_in "task_content", :with => content
    fill_in "task_start_at", :with => start_at
    fill_in "task_deadline_at", :with => deadline_at
    choose ('task_priority_' + priority)
    choose ('task_status_' + status)
    click_button I18n.t('submit')
    old_task.update(title: title, content: content, start_at: start_at, deadline_at: deadline_at, priority: priority, status: status)
  end

  # 測試 task 欄位的新增/編輯之後，應出現的資訊
  def check_page(message)
    expect(page).to have_content(message)
    expect(page).to have_content(title)
    expect(page).to have_content(content)
    expect(page).to have_content(start_at.to_s(:taskdate))
    expect(page).to have_content(deadline_at.to_s(:taskdate))
    expect(page).to have_content(priority)
    expect(page).to have_content(status)
  end

  # 產生不同日期順序的資料
  def create_sorted_date(col)
    column = col.to_sym
    2.times{ |n|
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
