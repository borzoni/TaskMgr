class NotificationMailerPreview < ActionMailer::Preview
  def account_activation
    @user = User.last
    @user.generate_activation_token
    NotificationMailer.account_activation(@user)
  end

  def password_recovery
    @user = User.last
    @user.generate_forgot_token
    NotificationMailer.password_recovery(@user)
  end
end
