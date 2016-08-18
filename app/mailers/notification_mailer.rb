class NotificationMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: @user.email, subject: 'Account activation'
  end

  def password_recovery(user)
    @user = user
    mail to: @user.email, subject: 'Password recovery'
  end
end
