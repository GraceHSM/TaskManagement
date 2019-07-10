class User < ApplicationRecord
  enum role: [:user, :admin]
  has_many :tasks
  has_many :tags
end
