# frozen_string_literal: true

module EstonianTld
  class SummaryService
    include Connector

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
    end

    def self.call(tld:)
      new(tld:).call
    end

    def call
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}/registrar/summary",
              method: 'get', params: nil, headers: nil)
    end
  end
end
