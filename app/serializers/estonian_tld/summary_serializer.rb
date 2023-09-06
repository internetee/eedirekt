module EstonianTld
  class SummarySerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def call
      notification = EstonianTld::NotificationSerializer.call(body: [dirty.body['data']['notification']]).first
      notifications_count = dirty.body['data']['notifications_count']
      username = dirty.body['data']['username']
      balance = EstonianTld::BalanceSerializer.call(body: dirty.body['data']['balance'])
      domains_count = dirty.body['data']['domains']
      contacts_count = dirty.body['data']['contacts']
      last_login_date = dirty.body['data']['last_login_date']

      {
        notification:,
        notifications_count:,
        username:,
        balance:,
        domains_count:,
        contacts_count:,
        last_login_date:
      }
    end
  end
end
