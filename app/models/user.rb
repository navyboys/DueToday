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
    lastest_open_todo = todos.where("STATUS = 'open' AND DUE < ?", Date.today).order(due: :desc).first
    lastest_open_todo ? lastest_open_todo.due : nil
  end
end
