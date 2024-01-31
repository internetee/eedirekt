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

    def create(domain, pending_action)
      payload = parse_domain(domain, pending_action)
      connect(url: "#{tld.base_url}#{REPP_ENDPOINT}/domains", method: 'post', params: payload, headers: nil)
    end

    private

    def parse_domain(domain, pending_action)
      period_in_months = pending_action.info['period'].to_i

      {
        domain: {
          name: domain.name,
          reserved_pw: domain.reserved_pw,
          registrant: domain.registrant.code,
          period_unit: 'm',
          period: period_in_months.to_i,
          nameservers_attributes: ns_attrs(domain.nameservers),
          admin_contacts: contacts(domain.contacts, 'admin'),
          tech_contacts: contacts(domain.contacts, 'tech'),
          dnskeys_attributes: domain.dnssec_keys,
        }
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
