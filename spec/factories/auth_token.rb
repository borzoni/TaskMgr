# frozen_string_literal: true
FactoryGirl.define do
  factory :auth_token do
    authenticatable factory: :user
  end
end
