OpenIDConnect.logger = Rails.logger
OpenIDConnect.debug!

OmniAuth.config.logger = Rails.logger
# Block GET requests to avoid exposing self to CVE-2015-9284
OmniAuth.config.allowed_request_methods = [:post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tara, setup: true
  # provider :tara, setup: lambda { |env|
  #   strategy = env['omniauth.strategy']
  #   initiator = env["QUERY_STRING"].split('&').first.split('=').last

  #   redirect_uri = "#{ENV['tara_base_redirect_url']}/#{initiator}#{ENV['tara_redirect_path']}"

  #   identifier, secret = if initiator == 'registrant'
  #     [ENV['user_tara_identifier'], ENV['user_tara_secret']]
  #   else
  #     [ENV['registrar_tara_identifier'], ENV['registrar_tara_secret']]
  #   end

  #   strategy.options.merge!({
  #     name: 'tara',
  #     scope: %w[openid idcard mid smartid],
  #     state: SecureRandom.hex(10),
  #     client_signing_alg: :RS256,
  #     client_jwk_signing_key: ENV['tara_keys'],
  #     send_scope_to_token_endpoint: false,
  #     send_nonce: true,
  #     issuer: ENV['tara_issuer'],
  #     discovery: ENV['tara_discovery'],
  #     client_options: {
  #       scheme: ENV['tara_scheme'],
  #       host: ENV['tara_host'],
  #       port: ENV['tara_port'],
  #       authorization_endpoint: ENV['tara_auth_endpoint'],
  #       token_endpoint: ENV['tara_token_endpoint'],
  #       userinfo_endpoint: nil, # Not implemented
  #       jwks_uri: ENV['tara_jwks_uri'],
  #       identifier:,
  #       secret:,
  #       redirect_uri:
  #     },
  #   })
  # }
end
