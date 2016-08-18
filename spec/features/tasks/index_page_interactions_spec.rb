require 'rails_helper'

shared_examples_for 'tasks_deletion' do |_|
  scenario 'user deletes tasks' do
    visit profile_tasks_path
    within("tr#task-#{tasks.first.id}") do
      first('a[name=\'delete\']').click
    end
    within('.modal-open') do
      find('.btn.commit').click
    end
    expect(page).to have_css('table.table tbody tr', visible: true, count: 4)
    expect_flash_with("Task #{tasks.first.name} deleted!")
  end
end
shared_examples_for 'tasks_statuses' do |_|
  scenario 'user starts task' do
    visit profile_tasks_path
    within("tr#task-#{tasks.first.id}") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first('a[name=\'start\']').click
    end
    expect(page).to have_css('button.btn.dropdown-toggle.btn-warning', visible: true, count: 1)
  end

  scenario 'user finishes task' do
    tasks.first.start!
    visit profile_tasks_path
    within("tr#task-#{tasks.first.id}") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first('a[name=\'finish\']').click
    end
    expect(page).to have_css('button.btn.dropdown-toggle.btn-danger', visible: true, count: 1)
  end

  scenario 'user reopens task after start' do
    tasks.first.start!
    visit profile_tasks_path
    within("tr#task-#{tasks.first.id}") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first('a[name=\'reopen\']').click
    end
    expect(page).to have_css('button.btn.dropdown-toggle.btn-success', visible: true, count: 5)
  end

  scenario 'user reopens task after finish' do
    tasks.first.start!
    tasks.first.finish!
    visit profile_tasks_path
    within("tr#task-#{tasks.first.id}") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first('a[name=\'reopen\']').click
    end
    expect(page).to have_css('button.btn.dropdown-toggle.btn-success', visible: true, count: 5)
  end
end

feature 'User manages tasks in task index page', js: true do
  context 'When admin' do
    let!(:user) { create(:user, :admin, :activated) }
    let!(:tasks) { create_list(:task, 5) }
    before { signin(user.email, user.password) }

    scenario 'user should see all tasks' do
      visit profile_tasks_path
      expect(page).to have_css('table.table tbody tr', visible: true, count: 5)
    end

    scenario 'user should see all columns' do
      visit profile_tasks_path
      within('table.table thead tr') do
        columns = all('th').map { |column| column.text.strip }
        columns.delete('')
        headers = %i(id name description created_at email)
        headers.each { |h| expect(columns).to include(Task.human_attribute_name(h)) }
      end
    end

    it_should_behave_like 'tasks_statuses'
    it_should_behave_like 'tasks_deletion'
  end

  context 'When user' do
    let!(:user) { create(:user, :activated) }
    let!(:tasks) { create_list(:task, 5, user: user) }
    let!(:other_tasks) { create_list(:task, 5) }
    before { signin(user.email, user.password) }

    scenario 'user should see only own tasks' do
      visit profile_tasks_path
      expect(page).to have_css('table.table tbody tr', visible: true, count: 5)
    end

    scenario 'user should not see assignee columns' do
      visit profile_tasks_path
      within('table.table thead tr') do
        columns = all('th').map { |column| column.text.strip }
        columns.delete('')
        expect(columns).not_to include(Task.human_attribute_name(:email))
      end
    end

    it_should_behave_like 'tasks_statuses'
    it_should_behave_like 'tasks_deletion'
  end
end
