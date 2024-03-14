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
      puts '-------- parse conacts --------'
      puts contacts(domain.domain_contacts, 'AdminDomainContact')
      puts contacts(domain.domain_contacts, 'TechDomainContact')
      puts '-------- parse conacts --------'

      # TODO: Some contact couldn't have code, so we need to create before contact in registry side
      # and then we should create domain

      period_in_months = pending_action.info['period'].to_i

      puts '--- DNS KEYS ---'
      puts dnssec_keys(domain.dnssec_keys)
      puts '--- DNS KEYS ---'

      {
        domain: {
          name: domain.name,
          reserved_pw: domain.reserved_pw,
          registrant: domain.registrant.code,
          period_unit: 'm',
          period: period_in_months.to_i,
          nameservers_attributes: ns_attrs(domain.nameservers),
          admin_contacts: contacts(domain.domain_contacts, 'AdminDomainContact'),
          tech_contacts: contacts(domain.domain_contacts, 'TechDomainContact'),
          dnskeys_attributes: dnssec_keys(domain.dnssec_keys),
        }
      }
    end

    def ns_attrs(nameservers)
      nameservers.map { |n| { hostname: n.hostname, ipv4: n.ipv4, ipv6: n.ipv6 } }
    end

    def dnssec_keys(dnssec_keys)
      dnssec_keys.map do |k|
        {
          flags: k.flags.to_s,
          protocol: k.protocol.to_s,
          alg: k.algorithm.to_s,
          public_key: k.public_key
        }
      end
    end

    def contacts(contacts, type)
      return [] unless contacts

      contact_ids = contacts.select { |c| c[:type] == type }.pluck(:contact_id)
      Contact.where(id: contact_ids).map(&:code)
    end
  end
end
