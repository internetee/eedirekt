module Tlds::EstTldValidation
  extend ActiveSupport::Concern

  class EppAuthorizationError < StandardError
    def initialize(message = I18n.t('.epp_authorization_error'))
      super(message)
    end
  end

  class ConnectionRegistryError < StandardError; end

  included do
    rescue_from EppAuthorizationError, with: :render_forbidden_error
    rescue_from ConnectionRegistryError, with: :internal_error
    rescue_from OpenSSL::SSL::SSLError, with: :internal_error_json
  end

  def server
    client_cert = File.open(@crt)
    client_key = File.open(@key)

    port = ENV['epp_port'] || '700'

    @server ||= Epp::Server.new({
                                  server: ENV['epp_hostname'],
                                  tag: @username,
                                  password: @password,
                                  port:,
                                  cert: OpenSSL::X509::Certificate.new(client_cert),
                                  key: OpenSSL::PKey::RSA.new(client_key)
                                })
  end

  def validate_existance_in_server
    res = server.open_connection
    unless Nokogiri::XML(res).css('greeting')
      Rails.logger.info('Failed to open connection to epp servicer')
      server.close_connection

      raise ConnectionRegistryError
    end

    ex = EppXml::Session.new(cl_trid_prefix: @username)
    xml = ex.login(clID: { value: @username }, pw: { value: @password })
    res = server.send_request(xml)

    Rails.logger.info '-------------- validate_existance_in_server'
    Rails.logger.info  Nokogiri::XML(res).css('result')
    Rails.logger.info '--------------'

    if Nokogiri::XML(res).css('result').first['code'] != '1000'
      raise EppAuthorizationError, Nokogiri::XML(res).css('result').css('msg').text
    end

    server.close_connection
  end

  def internal_error_json(exception)
    render json: {
      error: t('.ssl_error', exception:)
    }, status: :internal_server_error
  end

  def internal_error
    render 'errors/500', status: :internal_server_error, layout: 'error'
  end

  def render_forbidden_error(exception)
    render json: {
      error: t('.epp_forbidden', exception:)
    }, status: :forbidden
  end
end
