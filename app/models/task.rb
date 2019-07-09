class Task < ApplicationRecord
  belongs_to :user
  has_many :task_tags
  has_many :tags, through: :task_tags
end
