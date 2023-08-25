module EstonianTld
  class ContactService
    include Connector

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
      @url = "#{tld.base_url}#{REPP_ENDPOINT}"
    end

    def contact_list(url_params: {})
      connect(url: "#{@url}/contacts?#{url_params.to_query}", method: 'get', params: {}, headers: nil)
    end

    def create_contact(payload: nil)
      connect(url: "#{@url}/contacts", method: 'post', params: { contact: payload.payload.compact_blank.as_json }, headers: nil)
    end
  end
end
