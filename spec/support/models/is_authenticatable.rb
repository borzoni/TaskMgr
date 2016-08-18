shared_examples_for 'is_authenticatable' do
  let(:resource) { create(described_class.name.underscore) }
  subject { resource }
  it { should have_secure_password }
  it { should validate_length_of(:password).is_at_least(8) }
  it 'should have expirations' do
    expect(subject.class::TOKEN_EXPIRATIONS).to be_present
  end

  AuthToken.token_types.symbolize_keys.each_key do |token|
    it { should have_one(token) }
    it { should respond_to("generate_#{token}") }
    it { should respond_to("#{token}_clear") }
    it { should respond_to("#{token}_expired?") }
    it "should have expiration value for #{token}" do
      expect(subject.class::TOKEN_EXPIRATIONS[token]).to be_present
    end
  end

  it 'should generate common token' do
    expect(subject.remember_token).to be_nil
    subject.generate_remember_token
    expect(subject.remember_token).to be_truthy
  end

  it 'should have activation token pregenerated' do
    expect(subject.activation_token).to be_truthy
  end

  it 'should clear token' do
    subject.generate_remember_token
    subject.remember_token_clear
    expect(subject.reload.remember_token).to be_nil
  end

  it 'should verify valid token' do
    token = subject.generate_remember_token
    expect(subject.remember_token_verify(secret: token.secret, secret_id: token.secret_id)).to be_truthy
  end

  it 'should decline invalid token' do
    expect(subject.remember_token_verify(secret: '34232', secret_id: 'gddg')).to be_falsey
  end

  it 'should correctly differentiate between expired tokens' do
    token = subject.generate_forgot_token
    expect(subject.forgot_token_expired?).to be_falsey
    token.created_at -= subject.class::TOKEN_EXPIRATIONS[:forgot_token] + 1.second
    expect(subject.forgot_token_expired?).to be_truthy
  end

  it 'can be activated' do
    expect(subject.activated?).to be_falsey
    expect(subject.activated_at).to be_nil
    subject.activate
    expect(subject.activated?).to be_truthy
    expect(subject.reload.activation_token).to be_nil
    expect(subject.activated_at).to be_present
  end

  it 'should send activation email' do
    ActionMailer::Base.deliveries = []
    subject.send_activation_mail
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'should send password recovery email' do
    ActionMailer::Base.deliveries = []
    subject.generate_forgot_token
    subject.send_password_recovery_mail
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
