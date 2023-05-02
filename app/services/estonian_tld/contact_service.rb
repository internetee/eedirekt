module EstonianTld
  class ContactService
    include Connector

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
    end

    def contact_list(url_params: {})
      request(url: "#{tld.base_url}#{REPP_ENDPOINT}/contacts?#{url_params.to_query}", method: 'get', params: {}, headers: nil)
    end
  end
end
