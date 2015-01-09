class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :name, presence: true

  has_many :todos
  has_many :summaries

  has_secure_password

  def previous_day
    lastest_todo_before_today = todos.where('DUE < ?', Date.today).order(due: :desc).first
    lastest_todo_before_today ? lastest_todo_before_today.due : nil
  end

  def active_days(date_from, date_to)
    if date_from.nil? & date_to.nil?
      result_todos = todos.select('DUE').group('DUE')
    elsif date_from.nil?
      result_todos = todos.select('DUE').group('DUE').where('DUE <= ?', date_to)
    elsif date_to.nil?
      result_todos = todos.select('DUE').group('DUE').where('DUE >= ?', date_from)
    else
      result_todos = todos.select('DUE').group('DUE').where(due: date_from..date_to)
    end
    result_todos.each_with_object([]) { |todo, array| array << todo.due }
  end
end
