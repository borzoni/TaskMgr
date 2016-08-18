require 'rails_helper'

describe NotificationMailer, type: :mailer do
  describe 'Nofifier' do
    it 'sends account activation instructions' do
      user = create(:user)
      user.generate_activation_token
      NotificationMailer.account_activation(user).deliver_now
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('Account activation')
    end
    it 'sends password recovery instructions' do
      user = create(:user)
      user.generate_forgot_token
      NotificationMailer.password_recovery(user).deliver_now
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq('Password recovery')
    end
  end
end
