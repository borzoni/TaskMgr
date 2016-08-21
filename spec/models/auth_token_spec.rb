# frozen_string_literal: true
require 'rails_helper'

describe AuthToken do
  subject { build(:auth_token) }

  it { should belong_to(:authenticatable) }
  it { should validate_uniqueness_of(:secret_id) }
  # no validations for presense, because we're firing before validation callbacks
  # put it simply auth token always generates secret

  it 'should verify itself' do
    subject.save
    expect(subject.verify?(subject.secret)).to be_truthy
  end

  it 'should not verify nil' do
    subject.save
    expect(subject.verify?(nil)).to be_falsey
  end

  it 'should find token given valid secret_id and secret' do
    subject.save
    expect(AuthToken.find_authenticated(secret: subject.secret, secret_id: subject.secret_id)).to be_truthy
  end

  it 'should not find token given invalid secret_id and secret' do
    subject.save
    expect(AuthToken.find_authenticated(secret: 'invalid', secret_id: subject.secret_id)).to be_falsey
  end

  it 'should generate secret and its hash when saved' do
    expect(subject.secret).to be_nil
    expect(subject.hashed_secret).to be_nil
    subject.save
    expect(subject.secret).to be_present
    expect(subject.hashed_secret).to be_present
  end

  it 'should generate secret_id when saved' do
    expect(subject.secret_id).to be_nil
    subject.save
    expect(subject.secret_id).to be_present
  end

  it 'should not store secret in plain text in hashed_secret field' do
    subject.save
    expect(subject.secret_id).not_to be_eql(subject.hashed_secret)
  end
end
