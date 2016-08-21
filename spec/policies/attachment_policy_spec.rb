# frozen_string_literal: true
require 'rails_helper'

describe AttachmentPolicy do
  subject { AttachmentPolicy }

  let(:current_user) { create(:user, :activated) }
  let(:cu_attach) { create(:attachment, task: create(:task, user: current_user)) }
  let(:other_user) { create(:user, :activated) }
  let(:ou_attach) { create(:attachment, task: create(:task, user: other_user)) }
  let(:admin) { create(:user, :activated, :admin) }

  permissions :show? do
    it "prevents other users from seeing your task's attachments" do
      expect(subject).not_to permit(current_user, ou_attach)
    end
    it "allows you to see your own task's attachments" do
      expect(subject).to permit(current_user, cu_attach)
    end
    it 'allows an admin to see any attachment' do
      expect(subject).to permit(admin)
    end
  end
end
