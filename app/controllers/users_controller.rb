class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    params.permit!
    @user = User.new(params[:user])
    if @user.save
      AppMailer.delay.send_welcome_email(@user)
      redirect_to sign_in_path
    else
      render :new
    end
  end
end
