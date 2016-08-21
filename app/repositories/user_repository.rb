# frozen_string_literal: true
module UserRepository
  extend ActiveSupport::Concern

  included do
    scope :email_search, ->(query) do
      return all if query.blank?
      where('email ilike ?', "%#{query}%")
    end
  end

  class_methods do
    def filter(params = {})
      email_search(params[:query])
    end
  end
end
