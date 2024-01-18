require 'faraday'
require 'faraday/net_http'

module Payments
  module Everypay
    module Connection
      Faraday.default_adapter = :net_http

      def connection(options:)
        Faraday.new(options) do |faraday|
          faraday.adapter Faraday.default_adapter
        end
      end
    end
  end
end
