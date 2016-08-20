require 'active_support/concern'

module Authenticatable

  extend ActiveSupport::Concern
  included do
    # password stuff
    has_secure_password
    validates :password, presence: true, length: { minimum: 8 }, allow_blank: true

    # activation stuff
    enum activation: [:awaiting_activation, :activated]
    before_create :generate_activation_token

    # generate various long-living auth_tokens
    AuthToken.token_types.symbolize_keys.each_key do |token|
      has_one token, -> { where token_type: token }, class_name: AuthToken, dependent: :destroy, as: :authenticatable
    end
    TOKEN_EXPIRATIONS = { remember_token: 2.days, forgot_token: 2.hours, activation_token: 7.days }.freeze
  end
  AuthToken.token_types.symbolize_keys.each_key do |token|
    define_method "generate_#{token}" do
      public_send "create_#{token}", token_type: token
    end

    define_method "#{token}_expired?" do
      token_creation_date = public_send(token)&.created_at
      token_creation_date && (token_creation_date + TOKEN_EXPIRATIONS[token]).past?
    end

    define_method "#{token}_clear" do
      public_send(token)&.destroy
    end

    # validate token and check if it belongs to this user and not expired yet
    define_method "#{token}_verify" do |secret|
      return unless public_send(token)
      public_send(token) == AuthToken.find_authenticated(secret)
    end
  end

  def activate
    activation_token_clear
    update_columns(activated_at: Time.now, activation: :activated)
  end

  def send_activation_mail
    NotificationMailer.account_activation(self.email, self.activation_token.secret, self.activation_token.secret_id).deliver_later
  end

  def send_password_recovery_mail
    return false unless forgot_token
    NotificationMailer.password_recovery(self.email, self.forgot_token.secret, self.forgot_token.secret_id).deliver_later
  end
end
