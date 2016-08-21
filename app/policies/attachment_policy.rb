# frozen_string_literal: true
class AttachmentPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @attach = model
  end

  def show?
    @current_user.admin? || @current_user == @attach.task&.user
  end
end
