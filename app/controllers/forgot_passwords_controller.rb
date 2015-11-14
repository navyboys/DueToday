class ForgotPasswordsController < ApplicationController
  def create
    user = User.where(email: params[:email]).first
    if user
      user.update_column(:token, SecureRandom.urlsafe_base64)
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else
      if params[:email].blank?
        flash[:error] = 'Email cannot be blank.'
      else
        flash[:error] = 'There is no user with that email in the system.'
      end
      redirect_to forgot_password_path
    end
  end
end
