class Task < ApplicationRecord
  # 建立使用者之後再使用belongs_to
  # belongs_to :user
  # validates :user, presence: true

  validates :title, :content, :start_at, :deadline_at,  :priority, :status, presence: true
  validate :start_at_cannot_greater_than_deadline

  has_many :task_tags
  has_many :tags, through: :task_tags
  enum status: [:pending, :processing, :completed]
  enum priority: [:primary, :secondly, :common]

  scope :sorted_by, ->(sort_option) {
    direction = /desc$/.match?(sort_option) ? "desc" : "asc"
    case sort_option.to_s
    when /^created_at_/
      order("created_at #{direction}")
    end
  }

  def start_at_cannot_greater_than_deadline
    if start_at > deadline_at
      errors.add(:start_at, I18n.t('start_at_cannot_greater_than_deadline'))
    end
  end

end
