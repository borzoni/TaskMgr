# frozen_string_literal: true
require 'rails_helper'

describe User do
  subject { build(:user) }

  it { should have_many(:tasks).dependent(:destroy) }
  it { should respond_to(:email) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it_behaves_like 'is_authenticatable'

  context 'repository checks' do
    let!(:users) { create_list(:user, 5) }
    let!(:user) { create(:user) }

    it 'should find only one by query' do
      expect(User.filter(query: User.first.email).length).to be_eql(1)
    end

    it 'should find all by empty query' do
      expect(User.filter(query: nil).length).to be_eql(users.length + 1)
    end

    it 'should find all by given query' do
      expect(User.filter(query: 'test.com').length).to be_eql(users.length + 1)
    end
  end
end
