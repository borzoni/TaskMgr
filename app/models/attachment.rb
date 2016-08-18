class Attachment < ApplicationRecord

  belongs_to :task, optional: true
  mount_uploader :attach_file, AttachmentUploader
  validates :attach_file, presence: true

  def image?
    attach_file&.file&.content_type =~ %r{image\/.*}
  end

end
