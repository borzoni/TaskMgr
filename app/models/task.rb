# frozen_string_literal: true
class Task < ApplicationRecord
  include AASM
  include TaskRepository

  belongs_to :user
  validates :user_id, :name, presence: true
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :reject_attachments?, allow_destroy: true

  delegate :email, to: :user

  aasm column: 'state' do
    state :new, initial: true
    state :started, :finished

    event :start do
      transitions from: :new, to: :started
    end

    event :finish do
      transitions from: :started, to: :finished
    end

    event :reopen do
      transitions from: [:started, :finished], to: :new
    end
  end

  def reject_attachments?(attrs)
    attrs.slice(:id, :attach_file, :attach_file_cache).values.all?(&:blank?)
  end

  def build_attachments
    attachments.build if attachments.reject(&:marked_for_destruction?).blank?
  end
end
