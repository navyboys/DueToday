class Todo < ActiveRecord::Base
  validates :name, presence: true
  validates :status, presence: true
  validates :due, presence: true

  belongs_to :user
end
