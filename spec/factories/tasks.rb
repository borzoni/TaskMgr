FactoryGirl.define do
  factory :task do
    sequence(:name) {|n| "Task #{n}" }
    description { Faker::Lorem.sentences.join }
    user
  end
end
