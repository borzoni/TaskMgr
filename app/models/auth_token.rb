require 'securerandom'
# For longtermed tokens
class AuthToken < ApplicationRecord
  belongs_to :authenticatable, polymorphic: true
  validates :secret_id, presence: true, uniqueness: true
  validates :hashed_secret, presence: true
  before_validation :generate_secret_id, unless: :secret_id
  before_validation :generate_secret, unless: :secret
  attr_accessor :secret

  enum token_type: [:remember_token, :forgot_token, :activation_token]

  def self.find_authenticated(credentials)
    token = where(secret_id: credentials[:secret_id]).first
    token if token && token.verify?(credentials[:secret])
  end

  def verify?(secret)
    BCrypt::Password.new(hashed_secret) == secret
  end

  private

  def generate_secret_id
    loop do
      self.secret_id = SecureRandom.hex 8
      break unless self.class.exists?(secret_id: secret_id)
    end
  end

  def generate_secret
    self.secret = SecureRandom.urlsafe_base64 32
    self.hashed_secret = BCrypt::Password.create secret, cost: cost
  end

  def cost
    Rails.env.test? ? 1 : 10
  end
end
