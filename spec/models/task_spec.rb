require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user){ create(:user) }

  describe 'Search feature' do
    before :each do
      u = user
      create(:task, user_id: u.id, title: 'abc123', status: 'pending')
      create(:task, user_id: u.id, title: 'c12xy', status: 'completed')
      create(:task, user_id: u.id, title: 'xyz', status: 'completed')
    end
    it 'title' do
      task = Task.ransack(title_cont: 'c12').result
      expect(task.count).to eq 2
    end

    it 'status' do
      task = Task.ransack(status_eq: '2').result
      expect(task.count).to eq 2
    end

    it 'title and status' do
      task = Task.ransack(title_cont: 'xyz', status_eq: '2').result
      expect(task.count).to eq 1
    end
  end
end
