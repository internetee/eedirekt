module Payments
  module Everypay
class EverypayResponse
  include Payments::Everypay::Request

  attr_reader :payment_reference

  def initialize(payment_reference)
    @payment_reference = payment_reference
  end

  def self.call(payment_reference)
    fetcher = new(payment_reference)

    uri = fetcher.generate_url(payment_reference: payment_reference)
    fetcher.base_request(uri: uri)
  end

  def generate_url(payment_reference:)
    "#{ENV['everypay_base']}/payments/#{payment_reference}?api_username=#{ENV['api_username']}"
  end

  def base_request(uri:)
    get(path: uri)
  end
end
end
end
