module EstonianTld
  module DomainCreationProcess
    class CreateContactsJob < ApplicationJob
      queue_as :critical

      def perform(pending_action)
        return if pending_action.completed?

        @pending_action = pending_action

        contacts_what_not_exists = []
        contacts_without_code = []

        pending_action.info['admin_domain_contacts_attributes'].each do |_k, v|
          next if v['contact']['_destroy'] == 'true'
  
          contact = Contact.find_by(ident: v['contact']['ident'])
          if contact.nil?
            contacts_what_not_exists << v
          elsif contact.code.blank?
            contacts_without_code << v
          end
        end
  
        pending_action.info['tech_domain_contacts_attributes'].each do |_k, v|
          next if v['contact']['_destroy'] == 'true'
  
          contact = Contact.find_by(ident: v['contact']['ident'])

          if contact.nil?
            contacts_what_not_exists << v
          elsif contact.code.blank?
            contacts_without_code << v
          end
        end

        contacts_what_not_exists.each do |contact|
          create_contact(contact)
        end

        puts '---'
        puts contacts_what_not_exists
        puts contacts_without_code
        puts '---'

        (contacts_what_not_exists + contacts_without_code).each do |contact|
          # EstonianTld::CreateContactJob.perform_later(contact)
          user = Contact.find_by(ident: contact['contact']['ident'])

          puts '---- DO USER EXISTS ???'
          puts contact['contact']['ident']
          puts user.inspect
          puts '---- DO USER EXISTS ???'

          EstonianTld::CreateContactJob.perform_now(user)
        end
      end

      def create_contact(contact)
        # {"contact"=>{"name"=>"sanjoik", "role"=>"priv", "email"=>"sanjok@gmail.com", "ident"=>"51501017732", "phone"=>"5433432", "_destroy"=>"false", "phone_code"=>"372", "country_code"=>"EE"}}
        c = Contact.new(
          ident: contact['contact']['ident'],
          name: contact['contact']['name'],
          email: contact['contact']['email'],
          phone: contact['contact']['phone'],
          phone_code: contact['contact']['phone_code'],
          role: contact['contact']['role'],
          country_code: contact['contact']['country_code'],
          state: 'draft',
          street: 'street',
          city: 'city',
          zip: 'zip'
        )

        puts '--- DO CONTACT VALID ?'
        puts c.valid?
        puts c.errors.full_messages
        puts c.inspect
        puts '--- DO CONTACT VALID ?'

        c.save!
      end

      after_perform do |job|
        EstonianTld::DomainCreationProcess::CreateDomainJob.perform_now(@pending_action)
      end
    end
  end
end