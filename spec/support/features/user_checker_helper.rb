# frozen_string_literal: true
shared_examples_for 'user_form_common_checks' do |_|
  scenario 'user can not pass through with wrong email' do
    fill_user_form('test@mail.56', 'qwerty12345', 'qwerty12345', path)
    expect(page).to have_css('.form-group.has-error #user_email', visible: true, count: 1)
  end
  scenario 'user can not pass through with short password' do
    fill_user_form('test@mail.ru', 'qwe', 'qwe', path)
    expect(page).to have_css('.form-group.has-error #user_password', visible: true, count: 1)
  end
  scenario 'user can pass validation with valid fields' do
    fill_user_form('tested@mail.ru', 'qwerty12345', 'qwerty12345', path)
    expect(page).to have_css('li.list-group-item', count: 3)
  end
end
