class User < ActiveRecord::Base
  validates :email, presence: true
  validates :password, presence: true
  validates :user_name, presence: true
  validates :email, uniqueness: true

  has_secure_password
end
