require 'rails_helper'

feature 'User manages other users' do
  context 'When admin' do
    let(:user) { create(:user, :admin, :activated) }
    let!(:users) { create_list(:user, 4, :activated) }
    before { signin(user.email, user.password) }

    scenario 'user should see all users' do
      visit users_path
      expect(page).to have_css('table.table tbody tr', visible: true, count: 5)
    end

    scenario 'user should see all columns' do
      visit users_path
      within('table.table thead tr') do
        columns = all('th').map { |column| column.text.strip }
        columns.delete('')
        headers = %i(id email created_at)
        headers.each { |h| expect(columns).to include(User.human_attribute_name(h)) }
      end
    end

    scenario 'user can destroy user', js: true do
      visit users_path
      deleted_user = User.where(role: 0).first
      within("tr#user-#{deleted_user.id}") do
        first('a[name=\'delete\']').click
      end
      within('.modal-open') do
        find('.btn.commit').click
      end
      expect(page).to have_css('table.table tbody tr', visible: true, count: 4)
      expect_flash_with("User #{deleted_user.email} deleted")
    end

    scenario 'user can not destroy himself', js: true do
      visit users_path
      within("tr#user-#{user.id}") do
        first('a[name=\'delete\']').click
      end
      within('.modal-open') do
        find('.btn.commit').click
      end
      expect(page).to have_css('table.table tbody tr', visible: true, count: 5)
      expect_flash_with('Access denied.')
    end
  end

  context 'When user' do
    let(:user) { create(:user, :activated) }
    before { signin(user.email, user.password) }
    scenario 'user should not be allowed to access', js: true do
      visit users_path
      expect_flash_with('Access denied.')
    end
  end
end
