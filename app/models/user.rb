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
    if date_from.blank? && date_to.blank?
      todos.select('DUE').group('DUE')
    elsif date_from.blank?
      todos.select('DUE').group('DUE').where('DUE <= ?', date_to)
    elsif date_to.blank?
      todos.select('DUE').group('DUE').where('DUE >= ?', date_from)
    else
      todos.select('DUE').group('DUE').where(due: date_from..date_to)
    end
  end

  def day_job_processed?(date)
    if date.nil?
      return true
    elsif summaries.where(date: date).count == 0
      return false
    elsif todos.where(due: date, status: 'open').count == 0 &&
          summaries.select('description').where(date: date).first.description != ''
      return true
    else
      return false
    end
  end
end
