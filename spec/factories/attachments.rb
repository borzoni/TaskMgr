FactoryGirl.define do
  factory :attachment do
    attach_file { File.new(File.join(Rails.root, 'spec', 'support_files', 'test_attachments', 'test.pdf')) }
    task

    trait :image do
      attach_file { File.new(File.join(Rails.root, 'spec', 'support_files', 'test_attachments', 'test.png')) }
    end
  end
end
