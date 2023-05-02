module EstonianTld::Connector
  REPP_ENDPOINT = '/repp/v1'

  def request(url:, method:, params: nil, headers: nil)
    request = faraday_request(url:, headers:)
    response = if %w[get].include? method
                 request.send(method, url, params)
               else
                 request.send(method) do |req|
                   req.headers['Content-Type'] = 'application/json'
                   req.body = params.to_json
                 end
               end

    success = response.status == 200
    case response['content-type']
    when 'application/pdf'
      body = { data: response.body, message: response.headers['content-disposition'] }
    when %r{application/json}
      body = JSON.parse(response.body).with_indifferent_access
    else
      raise Faraday::Error, 'Unsupported content type'
    end
    OpenStruct.new(body: body,
      success: success,
      type: response['content-type'])
  rescue Faraday::Error => e
    OpenStruct.new(body: { code: 503, message: e.message,
      data: {} }, success: false)
  end

  def faraday_request(url:, headers: {})
    Faraday.new(
      url:,
      headers: headers.present? ? base_headers.merge!(headers) : base_headers,
      ssl: ca_auth_params
    )
  end

  def ca_auth_params
    return if Rails.env.test?

    client_cert = @tld.crt.download
    client_key = @tld.key.download
    {
      client_cert: OpenSSL::X509::Certificate.new(client_cert),
      client_key: OpenSSL::PKey::RSA.new(client_key)
    }
  end

  def base_headers
    { 'Authorization' => "Basic #{auth_token}" }
  end

  def auth_token
    @auth_token ||= generate_token(username: @tld.username, password: @tld.password)
  end

  def generate_token(username:, password:)
    Base64.urlsafe_encode64("#{username}:#{password}")
  end
end
