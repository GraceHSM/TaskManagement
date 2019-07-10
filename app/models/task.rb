class Task < ApplicationRecord
  enum status: [ :pending, :processing, :completed ]
  enum priority: [ :primary, :secondly, :thirdly, :common ]
  belongs_to :user
  has_many :task_tags
  has_many :tags, through: :task_tags
end
