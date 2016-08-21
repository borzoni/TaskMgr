# frozen_string_literal: true
require 'rails_helper'

feature 'User opens task', js: true do
  let(:user) { create(:user, :activated) }
  let(:task) { create(:task, :with_attachment, user: user) }
  before { signin(user.email, user.password) }

  scenario 'user should see relevant information' do
    visit task_path(task)
    expect(page).to have_css('li.list-group-item', count: 5)
    expect(page).to have_css('ul.attachments li', count: 1)
  end
end
