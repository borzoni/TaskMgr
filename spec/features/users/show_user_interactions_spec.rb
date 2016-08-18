require 'rails_helper'

feature 'User opens profile' do
  let(:user) { create(:user, :activated) }
  let!(:task) { create(:task, :with_attachment, user: user) }
  context 'when own profile' do
    before { signin(user.email, user.password) }
    it 'should see relevant information' do
      visit user_path(user)
      expect(page).to have_css('li.list-group-item', count: 3)
      expect(page).to have_css('table.tasks tbody tr', count: 1)
    end
  end
  context "when others's profile", js: true do
    let(:other) { create(:user, :activated) }
    before { signin(user.email, user.password) }
    it 'should be denied' do
      visit user_path(other)
      expect_flash_with('Access denied.')
    end
  end
  context "when admin and tries to see other's profile" do
    let(:admin) { create(:user, :admin, :activated) }
    before { signin(admin.email, admin.password) }
    it 'should be denied' do
      visit user_path(user)
      expect(page).to have_css('li.list-group-item', count: 3)
      expect(page).to have_css('table.tasks tbody tr', count: 1)
    end
  end
end
