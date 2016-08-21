# frozen_string_literal: true
class NotificationMailerPreview < ActionMailer::Preview
  def account_activation
    @user = User.last
    @user.generate_activation_token
    @email = @user.email
    @secret_id = @user.activation_token.secret_id
    @secret = @user.activation_token.secret
    NotificationMailer.account_activation(@email, @secret, @secret_id)
  end

  def password_recovery
    @user = User.last
    @user.generate_forgot_token
    @email = @user.email
    @secret_id = @user.forgot_token.secret_id
    @secret = @user.forgot_token.secret
    NotificationMailer.password_recovery(@user)
  end
end
