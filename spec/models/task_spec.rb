require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user){ create(:user) }
  before :each do
    user
    create(:task, user_id: user.id, title: 'abc123', status: 0)
    create(:task, user_id: user.id, title: 'c12xy', status: 2)
    create(:task, user_id: user.id, title: 'xyz', status: 2)
  end
  describe 'Search feature' do
    it 'title' do
      task = Task.ransack(title_cont:'c12').result
      expect(task.count).to eq 2
    end

    it 'status' do
      task = Task.ransack(status_eq:'2').result
      expect(task.count).to eq 2
    end

    it 'title and status' do
      task = Task.ransack(title_cont:'c12', status_eq:'2').result
      expect(task.count).to eq 1
    end
  end
end
