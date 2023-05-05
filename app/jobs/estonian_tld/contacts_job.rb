class EstonianTld::ContactsJob < ApplicationJob
  queue_as :critical

  STEP = 200

  def perform(tld)
    @tld = tld
    # NB! Synchronization should be run only one time when tld is added to the system
    return unless Contact.count.zero?

    url_params = {
      details: true,
      limit: STEP,
      offset: 0
    }

    dirty_contacs = EstonianTld::ContactService.new(tld:).contact_list(url_params:)

    unless dirty_contacs.success
      EstonianTld::InformAdminService.call({tld: , message: "Error fetching contacts: #{dirty_contacs.body['message']}"})
      return
    end

    total_count = dirty_contacs.body['data']['count']
    contact_count = dirty_contacs['body']['data']['contacts'].count
    contact_creator(dirty_contacs)

    EstonianTld::InformAdminService.call({tld: , message: 'Contacts start synchronizing!'})

    return if contact_count < STEP

    (STEP..total_count + STEP - 1).step(STEP) do |offset|
      url_params[:offset] = offset
      dirty_contacs = EstonianTld::ContactService.new(tld:).contact_list(url_params:)
      contact_creator(dirty_contacs)

      EstonianTld::InformAdminService.call({tld: , message: "Processed contacts #{url_params[:offset]} of #{total_count}"})
      Rails.logger.info "Processed contacts #{url_params[:offset]} of #{total_count}"
    end

    EstonianTld::InformAdminService.call({tld: , message: 'All contacts were synchronized!'})
  end

  def contact_creator(dirty_contacs)
    contacts = EstonianTld::ContactSerializer.call(dirty: dirty_contacs)
    contacts.each do |contact|
      c = ::Contact.find_by(code: contact.code)
      if c.nil?
        c = ::Contact.create!(contact.to_h)
        Rails.logger.info "Contact with code #{c.code} has been created!"
      end
    end
  end

  after_perform do |_job|
    EstonianTld::DomainsJob.perform_later(@tld)
  end
end
