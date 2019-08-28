class Task < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_one :sort_list, dependent: :destroy
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  validates :title, :content, presence: { message: I18n.t('must_be_presence') }
  validates :priority, :status, presence: true
  validates :start_at, presence: { message: I18n.t('must_be_choose_date') }
  validates :deadline_at, presence: { message: I18n.t('must_be_choose_date') }
  validate :start_at_cannot_greater_than_deadline

  enum status: { pending: 0, processing: 1, completed: 2 }
  enum priority: { primary: 0, secondly: 1, common: 2 }

  private
  def start_at_cannot_greater_than_deadline
    return if start_at.nil? || deadline_at.nil?
    if start_at > deadline_at
      errors.add(:start_at, I18n.t('start_at_cannot_greater_than_deadline'))
    end
  end

end
