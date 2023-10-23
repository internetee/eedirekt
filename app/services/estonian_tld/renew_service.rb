# frozen_string_literal: true

module EstonianTld
  class RenewService
    include Connector

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
    end

    def transfer(domain_name:, payload: {})
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}/domains/#{domain_name}/renew",
              method: 'post', params: renew_params(payload), headers: nil)
    end

    private

    def renew_params(payload)
      {
        renews: {
          period_unit: 'm',
          period: payload[:period].to_i,
          exp_date: payload[:expire_at]
        }
      }
    end
  end
end
