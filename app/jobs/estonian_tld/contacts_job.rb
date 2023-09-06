# rubocop:disable Style/ClassAndModuleChildren

class EstonianTld::ContactsJob < ApplicationJob
  queue_as :critical

  STEP = 200

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def perform(tld)
    @tld = tld
    @perform_callback = true
    # NB! Synchronization should be run only one time when tld is added to the system
    # return unless Contact.count.zero?

    url_params = {
      details: true,
      limit: STEP,
      offset: 0
    }

    dirty_contacs = EstonianTld::ContactService.new(tld:).contact_list(url_params:)

    unless dirty_contacs.success
      inform_admin_service(tld:, message: 'Error fetching contacts')
      @perform_callback = false

      return
    end

    total_count = dirty_contacs.body['data']['count']
    contact_count = dirty_contacs['body']['data']['contacts'].count
    contact_creator(dirty_contacs)

    return if contact_count < STEP

    (STEP..total_count + STEP - 1).step(STEP) do |offset|
      url_params[:offset] = offset
      dirty_contacs = EstonianTld::ContactService.new(tld:).contact_list(url_params:)
      contact_creator(dirty_contacs)

      inform_admin_service(tld:, message: "Processed contacts #{url_params[:offset]} of #{total_count}")

      Rails.logger.info "Processed contacts #{url_params[:offset]} of #{total_count}"
    end

    inform_admin_service(tld:, message: 'All contacts were synchronized!')
  end

  def contact_creator(dirty_contacs)
    contacts = EstonianTld::ContactSerializer.call(dirty: dirty_contacs)
    contacts_attributes = []

    contacts.each do |contact|
      next if ::Contact.exists?(code: contact.code)

      contacts_attributes << contact.to_h
    end

    ::Contact.upsert_all(contacts_attributes) unless contacts_attributes.empty?
  end

  def inform_admin_service(tld:, message:)
    EstonianTld::InformAdminService.call({ tld:, message: })
  end

  after_perform do |_job|
    # EstonianTld::DomainsJob.perform_later(@tld)
    EstonianTld::DomainsJob.perform_now(@tld) if @perform_callback
  end
end
