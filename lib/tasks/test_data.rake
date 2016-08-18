require 'factory_girl'
require 'faker'

desc 'Create test data'
task :create_dummy_tasks => :environment do
  FactoryGirl.create_list(:task, 20, :with_attachment, attachments_count: 2)
end
