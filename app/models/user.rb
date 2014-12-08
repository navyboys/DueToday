class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :nick_name, presence: true

  has_secure_password
end
