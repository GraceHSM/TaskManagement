class Task < ApplicationRecord
  # belongs_to :user
  # 建立使用者之後再使用belongs_to
  has_many :task_tags
  has_many :tags, through: :task_tags
  enum status: [:pending, :processing, :completed]
  enum priority: [:primary, :secondly, :common]

  # 在 model 裡使用 scope ，避免在 controller 呈現商業邏輯...但排序功能是否考量這個問題？
  # scope :order_by_created_asc, -> { order('created_at ASC') }
  # scope :order_by_created_desc, -> { order('created_at DESC') }


  # 使用類別方法帶參數
  # 缺 ） controller 程式碼會比較長
  # 優 ） 用不同欄位排序，可以重複使用此方法
  # ? )  網址會顯示欄位、排序是否合適？
  def self.order_by(column, order)
    order(%Q(#{ column } #{ order }))
  end

end
