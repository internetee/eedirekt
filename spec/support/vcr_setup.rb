require 'vcr'
require 'webdrivers'

module MyURI
  def self.parse(url)
    uri = URI.parse(url)
    uri.scheme = 'http'
    uri.host = 'registry'
    uri.port = '3000'
    uri
  end
end

VCR.configure do |config|
  config.debug_logger = File.open(Rails.root.join('log', 'vcr.log'), 'w')

  config.allow_http_connections_when_no_cassette = false
  config.uri_parser = MyURI
  config.ignore_localhost = true
  config.cassette_library_dir = 'vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
  config.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == 'ASCII-8BIT' ||
      !http_message.body.valid_encoding?
  end

  record_mode = ENV['VCR'] ? ENV['VCR'].to_sym : :once
  config.default_cassette_options = { record: record_mode }

  driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
  driver_hosts += ["github-releases.githubusercontent.com"]

  config.ignore_hosts(*driver_hosts)
end
