require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user){ create(:user) }
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }
  let(:start_at) { DateTime.now - 1 }
  let(:deadline_at) { DateTime.now + 1 }
  let(:priority) { ['primary', 'secondly', 'common'].sample }

  describe 'Search feature' do
    before :each do
      create_task('abc123', 'pending')
      create_task('c12xy', 'completed')
      create_task('xyz', 'completed')
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

  private
  def create_task(title, status)
    user.tasks.create(title: title, content: content, start_at: start_at, deadline_at: deadline_at, priority: priority, status: status)
  end
end
