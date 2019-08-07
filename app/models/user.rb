class User < ApplicationRecord
  before_destroy :vaild_admin_account
  has_many :tasks, dependent: :destroy
  validates :email, :username, :password, presence: true

  enum role: [:member, :admin]

  private
  def vaild_admin_account
    if self.role == 'admin'
      unless User.where(role: 'admin').count >= 1
        throw :abort
      end
    end
  end
end
