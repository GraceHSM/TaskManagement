require 'rails_helper'

RSpec.describe Task, :type => :feature do
  let(:user){ create(:user, role: 0) }
  let(:task){ create(:task, user_id: user.id) }
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }
  let(:start_at) { DateTime.now - 1 }
  let(:deadline_at) { DateTime.now + 1 }
  let(:priority) { ['primary', 'secondly', 'common'].sample }
  let(:status) { ['pending', 'processing', 'completed'].sample }
  describe 'Task CRUD' do
    it 'Read' do
      3.times{
        create(:task, user_id: user.id)
      }
      expect(Task.count).to be 3
      visit tasks_path
      expect(page).to have_text(Task.third.title)
    end

    it 'Create' do
      fill_in_new_task
      click_button I18n.t('submit')
      check_page(I18n.t('create_success'))
    end

    it 'Update' do
      old_task = task
      visit edit_task_path(old_task.id)
      edit_task(old_task)
      check_page(I18n.t('edit_success'))
    end

    it 'Destroy' do
      task
      visit tasks_path
      expect{ click_on I18n.t('delete') }.to change{ Task.count }.by(-1)
    end
  end

  # tasks sorted
  describe 'Tasks sorted' do
    context 'created at' do
      before :each do
        create_sorted_date('created_at')
        click_on I18n.t('created_at')
      end
      it 'ASC' do
        expect(first('.list').find('.created_at')).to have_text((DateTime.now - 1).to_s(:taskdate))
      end
      it 'DESC' do
        click_on I18n.t('created_at')
        expect(first('.list').find('.created_at')).to have_text((DateTime.now).to_s(:taskdate))
      end
    end

    context 'start at' do
      before :each do
        create_sorted_date('start_at')
        click_on I18n.t('start_at')
      end
      it 'ASC' do
        expect(first('.list').find('.start_at')).to have_text((DateTime.now - 1).to_s(:taskdate))
      end
      it 'DESC' do
        click_on I18n.t('start_at')
        expect(first('.list').find('.start_at')).to have_text((DateTime.now).to_s(:taskdate))
      end
    end

    context 'deadline at' do
      before :each do
        create_sorted_date('deadline_at')
        click_on I18n.t('deadline_at')
      end
      it "ASC" do
        expect(first('.list').find('.deadline_at')).to have_text((DateTime.now - 1).to_s(:taskdate))
      end
      it "DESC" do
        click_on I18n.t('deadline_at')
        expect(first('.list').find('.deadline_at')).to have_text((DateTime.now).to_s(:taskdate))
      end
    end

    context 'priority' do
      before :each do
        create(:task, user_id: user.id, priority: 0)
        create(:task, user_id: user.id, priority: 2)
        visit tasks_path
        click_on I18n.t('priority')
      end
      it 'ASC' do
        expect(first('.list').find('.priority')).to have_text(User.human_attribute_name('primary'))
      end
      it 'DESC' do
        click_on I18n.t('priority')
        expect(first('.list').find('.priority')).to have_text(User.human_attribute_name('common'))
      end
    end
  end

  # task 欄位驗證
  describe 'Validate task column' do
    before :each do
      fill_in_new_task
    end

    context 'presence' do
      after :each do
        expect(page).to have_content(I18n.t('must_be_presence'))
      end
      it 'title' do
        fill_in 'task_title', with: ''
        click_button I18n.t('submit')
      end
      it 'content' do
        fill_in 'task_content', with: ''
        click_button I18n.t('submit')
      end
    end

    context 'choose option' do
      after :each do
        expect(page).to have_content(I18n.t('must_be_choose_date'))
      end
      it 'start_at' do
        fill_in 'task_start_at', with: ''
        click_button I18n.t('submit')
      end
      it 'deadline_at' do
        fill_in 'task_deadline_at', with: ''
        click_button I18n.t('submit')
      end
    end

    it 'start_at_cannot_greater_than_deadline' do
      fill_in 'task_start_at', with: DateTime.now + 1
      fill_in 'task_deadline_at', with: DateTime.now - 1
      click_button I18n.t('submit')
      expect(page).to have_content(I18n.t('start_at_cannot_greater_than_deadline'))
    end
  end

  # Search feature spec
  describe 'Search tasks' do
    before :each do
      create(:task, user_id: user.id, title: 'abc123', status: 0)
      visit tasks_path
    end
    it 'status' do
      select(User.human_attribute_name('pending'), from: 'q_status_eq')
      click_on I18n.t('search')
      expect(page).to have_content(User.human_attribute_name('pending'))
    end
    it 'title' do
      fill_in 'q_title_cont', with: 'c12'
      click_on I18n.t('search')
      expect(page).to have_content('abc123')
    end

    it 'status and title' do
      fill_in 'q_title_cont', with: 'c12'
      select(User.human_attribute_name('pending'), from: 'q_status_eq')
      click_on I18n.t('search')
      expect(page).to have_content(User.human_attribute_name('pending'))
      expect(page).to have_content('abc123')
    end
  end

  private
  # Fill in new task
  def fill_in_new_task
    visit new_task_path
    fill_in 'task_title', with: title
    fill_in 'task_content', with: content
    fill_in 'task_start_at', with: start_at
    fill_in 'task_deadline_at', with: deadline_at
    choose ('task_priority_' + priority)
    choose ('task_status_' + status)
  end

  # 編輯並更新 task 欄位
  def edit_task(old_task)
    fill_in 'task_title', with: title
    fill_in 'task_content', with: content
    fill_in 'task_start_at', with: start_at
    fill_in 'task_deadline_at', with: deadline_at
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
    expect(page).to have_content(User.human_attribute_name(priority))
    expect(page).to have_content(User.human_attribute_name(status))
  end

  # 產生不同日期順序的資料
  def create_sorted_date(col)
    column = col.to_sym
    2.times{ |n|
      create(:task, user_id: user.id, column => (DateTime.now - n))
    }
    visit tasks_path
  end
end
