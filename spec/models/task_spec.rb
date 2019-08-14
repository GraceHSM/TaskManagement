require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user){ create(:user) }

  describe 'Search feature' do
    before :each do
      user
      create(:task, user_id: user.id, title: 'abc123', status: 'pending')
      create(:task, user_id: user.id, title: 'c12xy', status: 'completed')
      create(:task, user_id: user.id, title: 'xyz', status: 'completed')
    end

    it 'title' do
      task = user.tasks.ransack(title_cont: 'c12').result
      expect(task.count).to eq 2
    end

    it 'status' do
      task = user.tasks.ransack(status_eq: '2').result
      expect(task.count).to eq 2
    end

    it 'title and status' do
      task = user.tasks.ransack(title_cont: 'xyz', status_eq: '2').result
      expect(task.count).to eq 1
    end
  end
end
