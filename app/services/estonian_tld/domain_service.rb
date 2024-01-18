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

    def create(payload:)
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}/domains", method: 'post', params: domain_params(payload), headers: nil)
    end

    private

    def domain_params(payload)
      {
        domain: {
          name: payload[:name],
          reserved_pw: payload[:reserved_pw],
          registrant: payload[:registrant][:code],
          period_unit: payload[:period][-1].to_s,
          period: payload[:period].to_i,
          nameservers_attributes: ns_attrs(payload[:nameservers]),
          admin_contacts: contacts(payload[:contacts], 'admin'),
          tech_contacts: contacts(payload[:contacts], 'tech'),
          dnskeys_attributes: payload[:dns_keys],
        },
      }
    end

    def ns_attrs(nameservers)
      nameservers.map { |n| n.extract!(:hostname, :ipv4, :ipv6) }
    end

    def contacts(contacts, type)
      return [] unless contacts

      contacts.select { |c| c[:type] == type }.pluck(:code)
    end
  end
end
