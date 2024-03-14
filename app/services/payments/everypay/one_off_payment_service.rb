module Payments
  module Everypay
    class OneOffPaymentService
      include Payments::Everypay::Request

      attr_accessor :invoice, :user, :customer_url, :preferred_country, :locale

      def initialize(invoice:, customer_url: root_path, preferred_country: 'EE', locale: 'en')
        @invoice = invoice
        @customer_url = customer_url
        @preferred_country = preferred_country
        @locale = locale
      end

      def self.call(invoice:, customer_url: root_path, preferred_country: 'EE', locale: 'en')
        new(invoice: invoice, customer_url: customer_url, preferred_country: preferred_country, locale: locale).call
      end

      def call
        uri = URI("#{ENV['everypay_base']}/payments/oneoff")
        response = post(path: uri, params: body)

        struct_response(response)
      end

      private

      def struct_response(response)
        if response['error'].present?
          wrap(result: false, payload: nil, errors: response['error'])
        else
          wrap(result: true, payload: response&.with_indifferent_access, errors: nil)
        end
      rescue StandardError => e
        wrap(result: false, payload: nil, errors: e)
      end

      def wrap(**kwargs)
        result = kwargs[:result]
        payload = kwargs[:payload]
        errors = kwargs[:errors]
    
        Struct.new(:result?, :payload, :errors).new(result, payload, errors)
      end

      def body
        puts '====   customer url'
        puts customer_url
        puts '====   customer url'

        {
          'api_username' => ENV['api_username'],
          'account_name' => ENV['account_name'],
          'amount' => invoice.total.to_f,
          'order_reference' => invoice.number.to_s,
          'request_token' => false,
          'nonce' => "#{rand(10 ** 30).to_s.rjust(30,'0')}",
          'timestamp' => "#{Time.zone.now.to_formatted_s(:iso8601)}",
          'customer_url' => customer_url,
          'preferred_country' => 'EE',
          'locale' => 'en',
          # 'structured_reference' => 'ABC123'
        }
      end
    end
  end
end
