module EstonianTld
  class PollMessageService
    include Connector

    ALL_NOTIFICATION_RESOURCE = '/registrar/notifications/all_notifications'.freeze
    RESOURCE = '/registrar/notifications'.freeze

    attr_accessor :tld

    def initialize(tld:)
      @tld = tld
    end

    def all_notifications(url_params: {})
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}#{ALL_NOTIFICATION_RESOURCE}?#{url_params.to_query}",
              method: 'get', params: {}, headers: nil)
    end

    def last_unread
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}#{RESOURCE}",
              method: 'get', params: {}, headers: nil)
    end

    def mark_as_read(notification_id, payload: { read: true })
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}#{RESOURCE}/#{notification_id}",
              method: 'put', params: payload, headers: nil)
    end

    def get_specific(notification_id)
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}#{RESOURCE}/#{notification_id}",
              method: 'get', params: {}, headers: nil)
    end
  end
end
