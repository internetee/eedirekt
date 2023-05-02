module EstonianTld
  class PollMessage
    include Connector

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
    end

    def all
      request(url: "#{tld.base_url}#{REPP_ENDPOINT}/all_notifications", method: 'get', params: {}, headers: nil)
    end
  end
end
