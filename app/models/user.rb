class User < ApplicationRecord
  has_many :tasks
  # has_many :tags
  enum role: [:member, :admin]
end
