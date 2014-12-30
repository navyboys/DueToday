class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :name, presence: true

  has_many :todos
  has_many :summaries

  has_secure_password

  def todos_by_date(date)
    todos.where(due: date)
  end

  def previous_day
    lastest_todo_before_today = todos.where('DUE < ?', Date.today).order(due: :desc).first
    lastest_todo_before_today ? lastest_todo_before_today.due : nil
  end
end
