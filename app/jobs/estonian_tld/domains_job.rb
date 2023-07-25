# rubocop:disable Style/ClassAndModuleChildren
# rubocop:disable Style/Documentation
class EstonianTld::DomainsJob < ApplicationJob
  queue_as :critical

  STEP = 200

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def perform(tld)
    # NB! Synchronization should be run only one time when tld is added to the system
    # return unless Domain.count.zero?

    url_params = {
      details: true,
      limit: STEP,
      offset: 0
    }

    dirty_domains = EstonianTld::DomainService.new(tld:).domain_list(url_params:)

    unless dirty_domains.success
      EstonianTld::InformAdminService.call({tld: Tld.first, message: "Error fetching domains: #{dirty_domains.body['message']}"})
      return
    end

    total_count = dirty_domains.body['data']['count']
    contact_count = dirty_domains['body']['data']['domains'].count

    domain_creator(dirty_domains)

    EstonianTld::InformAdminService.call({ tld: Tld.first, message: 'Domains start synchronizing!' })

    return if contact_count < STEP

    (STEP..total_count + STEP - 1).step(STEP) do |offset|
      url_params[:offset] = offset
      dirty_domains = EstonianTld::DomainService.new(tld:).domain_list(url_params:)
      domain_creator(dirty_domains)

      EstonianTld::InformAdminService.call({tld: Tld.first, message: "Processed domains #{url_params[:offset]} of #{total_count}"})
      Rails.logger.info "Processed domains #{url_params[:offset]} of #{total_count}"
    end

    EstonianTld::InformAdminService.call({tld: Tld.first, message: 'All domains were synchronized!'})
    # ActionCable.server.broadcast "notifications:", message: 'All objects were synchronized!'
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable convention:Metrics/BlockLength
  # rubocop:disable Metrics/BlockLength
  def domain_creator(dirty_domains)
    dirty_domains.body['data']['domains'].each do |dirty|
      domain = EstonianTld::DomainSerializer.call(dirty:)
      domain_registrant = EstonianTld::DomainRegistrantSerializer.call(dirty:)
      domain_contacts = EstonianTld::DomainContactSerializer.call(dirty:)
      domain_nameservers = EstonianTld::DomainNameserverSerializer.call(dirty:)
      domain_dnskeys = EstonianTld::DomainDnskeySerializer.call(dirty:)

      d = ::Domain.find_by(name: domain.name)
      next if d.present?

      ActiveRecord::Base.transaction do
        begin
          registrant = ::Contact.find_by(code: domain_registrant.code)
          break if registrant.nil?

          domain = ::Domain.new(domain.to_h)
          domain.registrant_id = registrant.id
          domain.save(validate: false)

          domain_contacts.each do |contact|
            inner_contact = ::Contact.find_by(code: contact.code)
            DomainContact.create!(domain:, contact: inner_contact, type: contact.type)
          end

          domain_nameservers.each do |nameserver|
            Nameserver.create!(
              domain:, hostname: nameserver.hostname, ipv4: nameserver.ipv4, ipv6: nameserver.ipv6
            )
          end

          domain_dnskeys.each do |dnskey|
            DnssecKey.create!(
              domain:, flags: dnskey.flags, protocol: dnskey.protocol, algorithm: dnskey.alg, public_key: dnskey.public_key
            )
          end

          Rails.logger.info "Domain with name #{domain.name} has been created!"
        rescue ActiveRecord::StatementInvalid => e
          Rails.logger.warn e.message
        rescue ActiveRecord::Rollback => e
          Rails.logger.warn e.message
        end
      end
    end
  end
end
