require 'rails_helper'

feature 'User edits tasks' do
  context 'when admin' do
    let(:user) { create(:user, :admin, :activated) }
    let(:task) { create(:task, :with_attachment, user: user) }
    before { signin(user.email, user.password) }

    scenario 'user should not save invalid task' do
      visit edit_task_path(task)
      within("form#edit_task_#{task.id}") do
        fill_in 'task_name', with: ''
      end
      find('input[name="save"]').click
      expect(page).to have_css('div.has-error')
    end

    scenario 'user should save changes' do
      create(:user)
      visit edit_task_path(task)
      within("form#edit_task_#{task.id}") do
        fill_in 'task_name', with: 'Taaaask'
        fill_in 'task_description', with: 'Desc'
        find('#task_user_id').find(:xpath, 'option[2]').select_option
        first('#task_attachments_attributes_0_attach_file').set("#{Rails.root}/spec/support_files/test_attachments/test.png")
      end
      find('input[name="save"]').click
      expect(page).to have_css('li.list-group-item', count: 5)
    end
  end
  context 'When user' do
    let!(:user) { create(:user, :activated) }
    let(:task) { create(:task, :with_attachment, user: user) }
    before { signin(user.email, user.password) }

    scenario 'user should not save invalid task' do
      visit edit_task_path(task)
      within("form#edit_task_#{task.id}") do
        fill_in 'task_name', with: ''
      end
      find('input[name="save"]').click
      expect(page).to have_css('div.has-error')
    end

    scenario 'user should save changes' do
      visit edit_task_path(task)
      within("form#edit_task_#{task.id}") do
        fill_in 'task_name', with: 'Taaaask'
        fill_in 'task_description', with: 'Desc'
        first('#task_attachments_attributes_0_attach_file').set("#{Rails.root}/spec/support_files/test_attachments/test.pdf")
      end
      find('input[name="save"]').click
      expect(page).to have_css('li.list-group-item', count: 5)
    end
  end
end
