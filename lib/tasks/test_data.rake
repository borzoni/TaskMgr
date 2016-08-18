desc 'Create test data'
task dummy: :environment do
  FactoryGirl.create_list(:task, 20, :with_attachment, attachments_count: 2)
end
