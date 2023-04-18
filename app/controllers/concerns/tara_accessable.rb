class NoTaraCodeError < StandardError; end

module TaraAccessable
  extend ActiveSupport::Concern

  included do
    before_action :check_for_persisting_code, only: [:callback]
  end

  def access_token(code)
    auth = Base64.strict_encode64 [
      URI.encode_www_form_component(identifier),
      URI.encode_www_form_component(secret)
    ].join(':')
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded',
                'Authorization' => "Basic #{auth}" }

    response = connection.post(eeid_token_url) do |request|
      request.headers = headers
      request.body = { code: }
    end

    JSON.parse(response.body)
  end

  def userinfo(access_token)
    params = {
      access_token:,
      client_id: identifier
    }
    response = connection.get("#{eeid_userinfo_url}?#{params.to_query}")
    JSON.parse(response.body)
  end

  def connection
    Faraday.new(eeid_host)
  end

  def eeid_host
    'https://eeid.ee'
  end

  def eeid_token_url
    '/oidc/token'
  end

  def eeid_userinfo_url
    '/oidc/userinfo'
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
