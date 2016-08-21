# frozen_string_literal: true
module TaskRepository
  extend ActiveSupport::Concern

  included do
    scope :name_search, ->(query) do
      return all if query.blank?
      where([%w(name description).map { |a| "#{a} ilike :query" }.join(' OR '), query: "%#{query}%"])
    end
    scope :by_assignee, ->(user_id) { where(user_id: user_id) if user_id.present? }
  end

  class_methods do
    def filter(params = {})
      name_search(params[:query]).by_assignee(params[:assignee_id])
    end
  end
end
