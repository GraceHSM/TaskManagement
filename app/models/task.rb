class Task < ApplicationRecord
  # belongs_to :user
  # 建立使用者之後再使用belongs_to
  has_many :task_tags
  has_many :tags, through: :task_tags
  enum status: [:pending, :processing, :completed]
  enum priority: [:primary, :secondly, :common]
end
