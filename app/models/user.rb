class User < ApplicationRecord
  before_destroy :vaild_admin_account
  has_many :tasks, dependent: :destroy
  validates :email, :username, :password, presence: { message: I18n.t('must_be_presence') }
  validates :email, uniqueness: { message: I18n.t('the_email_has_already_been_used')}
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }

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
