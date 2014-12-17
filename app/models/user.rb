class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :nick_name, presence: true

  has_many :todos

  has_secure_password

  def todos_by_date(date)
    todos.where(due: date)
  end

  def previous_day_with_uncompleted_tasks
    lastest_open_todo = todos.where("STATUS = 'open' AND DUE < ?", Date.today).order(due: :desc).first
    lastest_open_todo ? lastest_open_todo.due : nil
  end
end
