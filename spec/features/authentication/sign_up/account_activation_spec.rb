require 'rails_helper'

feature 'Account Activation' do
  before(:all) do
    ActionMailer::Base.deliveries = []
    sign_up('test123@mail.ru', 'qwerty12345', 'qwerty12345')
    open_email('test123@mail.ru')
  end
  scenario 'user can activate his profile with valid link', js: true do
    current_email.click_link 'activation_link'
    expect_flash_with('Account activated!')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
  scenario 'user can not activate his profile with invalid link', js: true do
    visit edit_account_activation_path(id: 'random', secret: 'randon', email: 'test123@mail.ru')
    expect_flash_with('Invalid activation link')
  end
end
