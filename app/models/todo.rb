class Todo < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :user

  before_create :set_default_value

  def copy_to_today
    todo_copy = dup
    todo_copy.status = 'open'
    todo_copy.due = user.today
    todo_copy.save
  end

  def completed?
    status == 'completed'
  end

  def failed?
    status == 'failed'
  end

  private

  def set_default_value
    self.status = 'open' if status.blank?
    self.due = user.today if due.blank?
  end
end
