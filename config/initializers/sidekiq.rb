# if Rails.env.production?
  require 'sidekiq/web'

  # Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  #   username_valid = ActiveSupport::SecurityUtils.secure_compare(
  #     ::Digest::SHA256.hexdigest(username),
  #     ::Digest::SHA256.hexdigest(ENV['sidekiq_username'])
  #   )

  #   password_valid = ActiveSupport::SecurityUtils.secure_compare(
  #     ::Digest::SHA256.hexdigest(password),
  #     ::Digest::SHA256.hexdigest(ENV['sidekiq_password'])
  #   )

  #   username_valid & password_valid
  # end
# end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/9', namespace: 'sidekiq_eedirect' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/9', namespace: 'sidekiq_eedirect' }
end
