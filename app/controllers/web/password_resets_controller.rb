# frozen_string_literal: true
class Web::PasswordResetsController < Web::ApplicationController
  before_action :assert_not_auth
  before_action :load_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      @user.generate_forgot_token
      @user.send_password_recovery_mail
      flash[:notice] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      @user = User.new
      @user.errors.add(:email, 'not found')
      flash[:error] = 'Email address not found!'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user]&.[](:password).blank?
      @user.errors.add(:password, 'can\'t be empty')
      render 'edit'
    elsif params[:user]&.[](:password_confirmation).blank?
      @user.errors.add(:password_confirmation, 'can\'t be empty')
      render 'edit'
    elsif @user.update_attributes(user_params)
      @user.forgot_token_clear
      sign_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to profile_tasks_url
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user && @user.activated? && @user.forgot_token_verify(secret_id: params[:id], secret: params[:secret])
      flash[:error] = 'Password reset can\'t be applied for you.'
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.forgot_token_expired?
      flash[:error] = 'Password reset has expired.'
      redirect_to new_password_reset_url
    end
  end
end
