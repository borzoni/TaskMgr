class User < ApplicationRecord
  include Authenticatable
  include UserRepository

  before_save { self.email = email.downcase }
  validates :email, uniqueness: true, presence: true, email: true
  has_many :tasks, dependent: :destroy
  enum role: [:user, :admin]
end
