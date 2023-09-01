# frozen_string_literal: true

module EstonianTld
  class TransferService
    include Connector

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
    end

    def transfer(payload: {})
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}/domains/transfer", method: 'post', params: transfer_params(payload),
              headers: nil)
    end

    private

    def transfer_params(payload)
      {
        data: {
          domain_transfers: [payload]
        }
      }
    end
  end
end
