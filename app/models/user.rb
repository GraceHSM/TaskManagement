class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  # validates :email, confirmation: true
  # validates :email_confirmation, presence: true

  enum role: [:member, :admin]
end
