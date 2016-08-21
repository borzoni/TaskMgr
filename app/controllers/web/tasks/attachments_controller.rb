# frozen_string_literal: true
class Web::Tasks::AttachmentsController < Web::Tasks::ApplicationController
  before_action :assert_auth
  after_action :verify_authorized

  def show
    @attachment = resource_task.attachments.find(params[:id])
    authorize @attachment
    if @attachment.image?
      type = params[:img_version]
      base = @attachment.attach_file
      base = base.versions[type.to_sym] if type
      send_data File.open(base.path, 'rb').read, type: @attachment.attach_file.file.content_type, disposition: 'inline'
    else
      send_file @attachment.attach_file.path, type: @attachment.attach_file.file.content_type, filename: @attachment.attach_file.file.filename, stream: false
    end
  end
end
