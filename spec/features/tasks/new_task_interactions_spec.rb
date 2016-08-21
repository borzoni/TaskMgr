# frozen_string_literal: true
require 'rails_helper'

feature 'User creates new task' do
  context 'When admin' do
    before do
      user = create(:user, :admin, :activated)
      signin(user.email, user.password)
    end

    scenario 'user shouldn not create task provided validations fail' do
      visit new_task_path
      find('input[name="save"]').click
      expect(page).to have_css('div.has-error')
    end

    scenario 'user should create to other user' do
      create(:user)
      visit new_task_path
      within('form#new_task') do
        fill_in 'task_name', with: 'New'
        fill_in 'task_description', with: 'Description'
        find('#task_user_id').find(:xpath, 'option[2]').select_option
        first('#task_attachments_attributes_0_attach_file').set("#{Rails.root}/spec/support_files/test_attachments/test.pdf")
      end
      find('input[name="save"]').click
      expect(page).to have_css('li.list-group-item', count: 5)
    end
  end

  context 'When user' do
    before do
      user = create(:user, :activated)
      signin(user.email, user.password)
    end
    scenario 'user should not create task provided validations fail' do
      visit new_task_path
      find('input[name="save"]').click
      expect(page).to have_css('div.has-error')
    end

    scenario 'user should not see assignee control' do
      visit new_task_path
      within('form#new_task') do
        expect(page).not_to have_css('#task_user_id')
      end
    end

    scenario 'user should create valid task' do
      visit new_task_path
      within('form#new_task') do
        fill_in 'task_name', with: 'New'
        fill_in 'task_description', with: 'Description'
        first('#task_attachments_attributes_0_attach_file').set("#{Rails.root}/spec/support_files/test_attachments/test.png")
      end
      find('input[name="save"]').click
      expect(page).to have_css('li.list-group-item', count: 5)
    end
  end
end
