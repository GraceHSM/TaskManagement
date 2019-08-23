class User < ApplicationRecord
  # before_save :digest_password
  before_destroy :vaild_admin_account

  has_many :tasks, dependent: :destroy

  validates :username, presence: { message: I18n.t('must_be_presence') }
  validates :email, :password, on: :create, presence: { message: I18n.t('must_be_presence') }
  validates :email, on: :create, uniqueness: { message: I18n.t('the_email_has_already_been_used')}
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :password, length: { minimum: 6 }, on: :create

  enum role: { member: 0, admin: 1 }

  private
  # def digest_password
  #   self.password = Digest::SHA256.hexdigest password
  # end

  def vaild_admin_account
    if admin?
      if User.admin.count <= 1
        throw :abort
      end
    end
  end
end
