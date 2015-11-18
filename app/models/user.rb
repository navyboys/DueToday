class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :name, presence: true

  has_many :todos
  has_many :summaries

  has_secure_password

  has_attached_file :avatar, styles: { thumb: '20x20#', medium: '200x200#' }, default_url: '/images/:style/missing.png'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def previous_day
    today_in_time_zone = Time.now.in_time_zone(time_zone).to_date
    lastest_todo_before_today = todos.where('DUE < ?', today_in_time_zone).order(due: :desc).first
    lastest_todo_before_today ? lastest_todo_before_today.due : nil
  end

  def active_days(date_from, date_to)
    if date_from.blank? && date_to.blank?
      todos.select('DUE').group('DUE').order(due: :desc)
    elsif date_from.blank?
      todos.select('DUE').group('DUE').where('DUE <= ?', date_to).order(due: :desc)
    elsif date_to.blank?
      todos.select('DUE').group('DUE').where('DUE >= ?', date_from).order(due: :desc)
    else
      todos.select('DUE').group('DUE').where(due: date_from..date_to).order(due: :desc)
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
