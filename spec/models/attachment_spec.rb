# frozen_string_literal: true
require 'rails_helper'

describe Attachment do
  subject { build(:attachment) }

  it { should belong_to(:task) }

  context 'file validations' do
    it 'should not be valid if no file attached' do
      attachment = Attachment.new
      attachment.valid?
      expect(attachment.errors[:attach_file]).to be_present
    end

    it 'should be valid if file attached' do
      attachment = Attachment.new(attach_file: File.new(File.join(Rails.root, 'spec', 'support_files', 'test_attachments', 'test.pdf')))
      attachment.valid?
      expect(attachment.errors[:attach_file]).to be_blank
    end
  end

  context 'check if image' do
    it 'should not be an image' do
      expect(subject.image?).to be_falsey
    end

    it 'should be an image' do
      attachment = create(:attachment, :image)
      expect(attachment.image?).to be_truthy
    end
  end

  it 'return a valid url to attachment' do
    subject.save
    expect(subject.attach_file.url).to be_eql("tasks/#{subject.task.id}/attachments/#{subject.id}")
  end
end
