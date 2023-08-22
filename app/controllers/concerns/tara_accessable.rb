class NoTaraCodeError < StandardError; end

module TaraAccessable
  extend ActiveSupport::Concern

  included do
    before_action :check_for_persisting_code, only: [:callback]
  end

  def tara_params_initiator
    request.env['omniauth.params']['env']
  end

  # rubocop:disable Metrics/MethodLength
  def options
    {
      name: 'tara',
      scope: %w[openid idcard mid smartid],
      state: SecureRandom.hex(10),
      client_signing_alg: :RS256,
      client_jwk_signing_key: ENV['tara_keys'],
      send_scope_to_token_endpoint: false,
      send_nonce: true,
      issuer: ENV['tara_issuer'],
      discovery: ENV['tara_discovery'],
      client_options: {
        scheme: ENV['tara_scheme'],
        host: ENV['tara_host'],
        port: ENV['tara_port'],
        authorization_endpoint: ENV['tara_auth_endpoint'],
        token_endpoint: ENV['tara_token_endpoint'],
        userinfo_endpoint: nil, # Not implemented
        jwks_uri: ENV['tara_jwks_uri'],
        identifier: ENV['user_tara_identifier'],
        secret: ENV['user_tara_secret'],
        redirect_uri: "#{ENV['tara_base_redirect_url']}#{ENV['tara_redirect_path']}"
      }
    }
  end

  private

  def check_for_persisting_code
    handle_callback_error and return if params[:error].present?
    raise NoTaraCodeError unless params[:code].present?
  end

  def handle_callback_error
    render 'sessions/new', notice: { alert: params[:error] }, status: :unprocessable_entity
  end
end
