require 'rails_helper'

feature 'User visits root page', js: true do
  context 'When navigation not authenticated' do
    scenario 'sees sign in link' do
      visit root_path
      expect(page).to have_css('#sign-in_link', visible: true, count: 1)
    end
  end

  context 'When navigation authenticated' do
    let!(:user) { create(:user, :activated) }
    before { signin(user.email, user.password) }

    scenario 'sees sign out link' do
      expect(page).to have_css('#sign-out_link')
    end

    scenario 'sees edit profile' do
      expect(page).to have_css('#your_profile')
    end
  end

  context 'When list view' do
    scenario 'no tasks - empty list view' do
      visit root_path
      expect(page).to have_css('.no-items-container', visible: true, count: 1)
    end

    scenario 'with tasks sees all tasks' do
      create_list(:task, 10)
      visit root_path
      expect(page).to have_css('table.table.table-striped tbody tr', count: 10)
    end
  end
end
