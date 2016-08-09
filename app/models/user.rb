class User < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  after_initialize :set_default_role, :if => :new_record?
  enum role: [:user, :admin]

	def set_default_role
		self.role ||= :user
	end
end  
