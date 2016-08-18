FactoryGirl.define do
  factory :task do
    sequence(:name) { |n| "Task #{n}" }
    description { Faker::Lorem.sentences.join }
    transient do
      attachments_count 1
    end
    user
  end

  trait :with_attachment do
    after :create do |task, evaluator|
      FactoryGirl.create_list(:attachment, evaluator.attachments_count, task_id: task.id)
    end
  end
end
