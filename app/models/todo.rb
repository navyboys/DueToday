class Todo < ActiveRecord::Base
  validates :title, presence: true
  validates :status, presence: true
  validates :due, presence: true

  belongs_to :user

  before_create :set_default_value

  def copy_to_today
    todo_copy = dup
    todo_copy.status = 'open'
    todo_copy.due = Date.today
    todo_copy.save
  end

  private

  def set_default_value
    self.status = 'open'
    self.due = Date.today
  end
end
