class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: 'navyboys@gmail.com', subject: 'Welcome to DueToday!'
  end
end