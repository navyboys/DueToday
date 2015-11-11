class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.delay.send_welcome_email(@user)
      redirect_to sign_in_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Your profile was updated.'
      redirect_to :back
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
