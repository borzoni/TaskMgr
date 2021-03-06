# frozen_string_literal: true
Sidekiq.configure_client do |config|
  config.redis = { size: 3 }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 20 }
end
