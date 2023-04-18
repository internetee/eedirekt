class Tld < ApplicationRecord
  has_secure_password

  has_one_attached :crt
  has_one_attached :key

  # validate :validate_existance_in_server

  def self.permitted_attributes
    %i[username password crt key]
  end

  # def server
  #   cert_path = ActiveStorage::Blob.service.path_for(cert.key)

  #   port = ENV['epp_port'] || '700'

  #   @server ||= Epp::Server.new({
  #     server: ENV['epp_hostname'],
  #     tag: username,
  #     password:,
  #     port:,
  #     cert: OpenSSL::X509::Certificate.new(File.open(cert_path)),
  #     key: OpenSSL::PKey::RSA.new(key.download)
  #   })
  # end

  # def request(xml)
  #   Nokogiri::XML(server.request(xml)).remove_namespaces!
  # end

  # def validate_existance_in_server
  #   return if errors.any?

  #   res = server.open_connection

  #   unless Nokogiri::XML(res).css('greeting')
  #     errors.add(:base, :failed_to_open_connection_to_epp_server)
  #     server.close_connection # just in case
  #     return
  #   end

  #   ex = EppXml::Session.new(cl_trid_prefix: tag)
  #   xml = ex.login(clID: { value: tag }, pw: { value: password })
  #   res = server.send_request(xml)

  #   if Nokogiri::XML(res).css('result').first['code'] != '1000'
  #     errors.add(:base, :authorization_error)
  #   end

  #   server.close_connection
  # rescue OpenSSL::SSL::SSLError => e
  #   Rails.logger.error e
  #   errors.add(:base, :invalid_cert)
  # end
end
