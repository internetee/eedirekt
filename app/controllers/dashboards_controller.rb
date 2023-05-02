class DashboardsController < ApplicationController
  def index; end

  private

  # def server
  #   crt_content = Tld.first.crt.download
  #   key_content = Tld.first.key.download

  #   @server ||= Epp::Server.new({
  #     server: 'epp_proxy',
  #     tag: 'oleghasjanov',
  #     password: '123456',
  #     port: '700',
  #     cert: OpenSSL::X509::Certificate.new(crt_content),
  #     key: OpenSSL::PKey::RSA.new(key_content)
  #   })
  # end

  # def api_user
  #   @tld_user = Tld.first
  # end
end
