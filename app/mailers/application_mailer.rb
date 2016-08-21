# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'from@valucon.task-mgr.com'
  layout 'mailer'
end
