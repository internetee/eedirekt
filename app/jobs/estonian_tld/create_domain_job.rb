class EstonianTld::CreateDomainJob < ApplicationJob
  queue_as :critical

  def perform(pending_action)
    return if pending_action.completed?
    
    admin_contact = Contact.find_by(code: pending_action.user.code)
    tech_contact = Contact.find_by(code: Setting['code_of_technical_contact'] || pending_action.user.code)
    
    expire_at = calculate_expiry(pending_action.info['period'].to_i)

    registrant_contact = Contact.find_by(code: pending_action.user.code)

    domain = Domain.find_by(name: pending_action.info['name'])
    
    if domain.nil?
      domain = Domain.new(
        name: pending_action.info['name'],
        registrant_id: registrant_contact.id,
        expire_at: expire_at,
        reserved_pw: pending_action.info['reserved_pw'],
        domain_contacts: [
          AdminDomainContact.new(
            contact_id: admin_contact.id,
          ),
          TechDomainContact.new(
            contact_id: tech_contact.id,
          ),
        ],
        nameservers: Setting['default_nameserver_records'] || [],
        dnssec_keys: Setting['dnssec_enabled'] ? Setting['default_dnssec_keys'] : [],
      )
      REPP_ENDPOINT

    if domain.save
      # response = EstonianTld::DomainService.new(tld: Tld.first).create(domain, pending_action)

      response = current_api_adapter.create_domain(domain: domain, pending_action: pending_action)

      if response.success
        pending_action.update(status: :completed)
        domain.update(state: :active)
      else
        pending_action.update(status: :failed, errors_in_response: response.body)
        inform_registrant_service(tld: Tld.first, message: response.body)

        Rails.logger.info '------ error -----'
        Rails.logger.info response.body
        Rails.logger.info '------ error -----'
      end

      Rails.logger.info "Domain #{domain.name} was created!"
    else
      Rails.logger.info domain.errors.inspect
    end
  end

  private

  def inform_registrant_service(tld:, message:)
    EstonianTld::InformRegistrantService.call({ tld:, message: })
  end

  def ns_attrs(nameservers)
    nameservers.map { |n| n.extract!(:hostname, :ipv4, :ipv6) }
  end

  def contacts(contacts, type)
    return [] unless contacts

    contacts.select { |c| c[:type] == type }.pluck(:code)
  end

  # TODO: Need to complete this method
  def domain_params(domain)
    {
      domain: {
        name: domain.name,
        reserved_pw: domain.reserved_pw,
        registrant: domain.registrant.code,
        # TODO: domain no store period unit value !!! period_unit: payload[:period][-1].to_s,
        # TODO: domain no store perion value !!! period: payload[:period].to_i,
        nameservers_attributes: ns_attrs(payload[:nameservers]),
        admin_contacts: contacts(payload[:contacts], 'admin'),
        tech_contacts: contacts(payload[:contacts], 'tech'),
        dnskeys_attributes: payload[:dns_keys],
      },
    }
  end

  def calculate_expiry(period)
    (Time.zone.now.advance(months: period) + 1.day).beginning_of_day
  end
end
