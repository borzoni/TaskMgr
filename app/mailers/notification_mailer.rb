class NotificationMailer < ApplicationMailer
  def account_activation(email, secret, secret_id)
    @secret = secret
    @secret_id = secret_id
    @email = email
    mail to: email, subject: 'Account activation'
  end

  def password_recovery(email, secret, secret_id)
    @secret = secret
    @secret_id = secret_id
    @email = email
    mail to: email, subject: 'Password recovery'
  end
end
