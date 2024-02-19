module EstonianTld
  module DomainCreationProcess
    class CreateDomainJob < ApplicationJob
      queue_as :critical

      def perform(pending_action)
        return if pending_action.completed?
        
      # initialize AdminDomainContact and TechDomainContact for domain contracts attribute of domain
        domain_contacts = initialize_domain_contacts(pending_action)

        expire_at = calculate_expiry(pending_action.info['period'].to_i)

        registrant_contact = Contact.find_by(code: pending_action.user.code)

        domain = Domain.find_by(name: pending_action.info['name'])
        
        
        p '------- Setting[dnssec_enabled] -----'
        p Setting.dnssec_enabled
        p '------- Setting[dnssec_enabled] -----'

        if domain.nil?
          domain = Domain.new(
            name: pending_action.info['name'].strip.downcase,
            registrant_id: registrant_contact.id,
            expire_at: expire_at,
            reserved_pw: pending_action.info['reserved_pw'],
            domain_contacts: domain_contacts,
            nameservers: initialize_nameservers(pending_action),
            dnssec_keys: Setting.dnssec_enabled ? initialize_dnssec_keys(pending_action) : [],
          )
        end

        if domain.save
          current_api_adapter = ApplicationController.new.current_api_adapter
          response = current_api_adapter.create_domain(domain: domain, pending_action: pending_action)

          if response.success
            pending_action.complete!
            domain.activate!
          else
            pending_action.update(errors_in_response: response.body)
            pending_action.fail!

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

      def initialize_domain_contacts(pending_action)
        tech_domain_contacts = pending_action.info['tech_domain_contacts_attributes'].map do |_k, v|
          next if v['contact']['_destroy'] == 'true'

          contact = Contact.find_by(ident: v['contact']['ident'])
          contact = initialize_contact(v) if contact.nil?

          TechDomainContact.new(contact: contact)
        end

        admin_domain_contacts = pending_action.info['admin_domain_contacts_attributes'].map do |_k, v|
          next if v['contact']['_destroy'] == 'true'

          contact = Contact.find_by(ident: v['contact']['ident'])
          contact = initialize_contact(v) if contact.nil?

          AdminDomainContact.new(contact: contact)
        end

        tech_domain_contacts + admin_domain_contacts
      end

      def initialize_nameservers(pending_action)
        pending_action.info['nameservers_attributes'].map do |_k, v|
          Nameserver.new(
            hostname: v['hostname'],
            ipv4: v['ipv4'],
            ipv6: v['ipv6']
          )
        end
      end

      def initialize_dnssec_keys(pending_action)
        pending_action.info['dnssec_keys_attributes'].map do |_k, v|
          DnssecKey.new(
            flags: v['flags'],
            protocol: v['protocol'],
            algorithm: v['algorithm'],
            public_key: v['public_key']
          )
        end
      end

      def initialize_contact(v)
        Contact.new(
            name: v['contact']['name'],
            email: v['contact']['email'],
            ident: v['contact']['ident'],
            country_code: 'EE',
            role: v['contact']['role'],
            phone: '59813313',
            phone_code: '372'
          )
      end


      def calculate_expiry(period)
        (Time.zone.now.advance(months: period) + 1.day).beginning_of_day
      end
    end
  end
end
