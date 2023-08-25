module EstonianTld
  class DomainService
    include Connector

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
    end

    def domain_list(url_params: {})
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}/domains?#{url_params.to_query}", method: 'get', params: {}, headers: nil)
    end
  end
end
