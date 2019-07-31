class Task < ApplicationRecord
  # 建立使用者之後再使用belongs_to
  # belongs_to :user
  # validates :user, presence: true
  validates :title, :content, presence: { message: I18n.t('must_be_presence') }
  validates :start_at, :deadline_at, presence: { message: I18n.t('must_be_choose_date') }
  validates :priority, :status, presence: { message: I18n.t('must_be_choose_option') }
  validate :start_at_cannot_greater_than_deadline

  has_many :task_tags
  has_many :tags, through: :task_tags
  enum status: [:pending, :processing, :completed]
  enum priority: [:primary, :secondly, :common]

  scope :sorted_by, ->(sort_option) {
    direction = /desc$/.match?(sort_option) ? "desc" : "asc"
    case sort_option.to_s
    when ''
      order("id #{direction}")
    when /^created_at_/
      order("created_at #{direction}")
    when /^start_at_/
      order("start_at #{direction}")
    when /^deadline_at_/
      order("deadline_at #{direction}")
    when /^status/
      order("status #{direction}")
    end
  }

  private
  def start_at_cannot_greater_than_deadline
    return if start_at.nil? || deadline_at.nil?
    if start_at > deadline_at
      errors.add(:start_at, I18n.t('start_at_cannot_greater_than_deadline'))
    end
  end

end
