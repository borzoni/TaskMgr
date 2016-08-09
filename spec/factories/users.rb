FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@test.com" }

    password '123456'
    password_confirmation '123456'

    trait :admin do
      role 'admin'
    end
  end
end
