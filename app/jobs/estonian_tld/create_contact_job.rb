class EstonianTld::CreateContactJob < ApplicationJob
  queue_as :critical

  def perform(user)
    contact = Contact.find_by(ident: user.ident)

    if contact && contact.code.present?
      puts '== AU PIDAR'
      user.update!(code: contact.code) if user.code.blank?
      return
    end

    payload = contact_payload(user)
    response = EstonianTld::ContactService.new(tld: Tld.first).create_contact(payload:)

    if response.success
      code = response.body["data"]["contact"]["code"]
      
      if contact && contact.code.blank?
        ActiveRecord::Base.transaction do
          contact.update!(code: code)
          user.update!(code: code)
        end
      else
        ActiveRecord::Base.transaction do
          user.update!(code: code)
          create_contact(user)
        end
      end
    else
      Rails.logger.info response.body["message"]
    end
  end

  def create_contact(registrant_user)
    Contact.create(
      ident: registrant_user.ident,
      name: 'TODO: add name',
      email: registrant_user.email,
      phone: registrant_user.phone,
      phone_code: registrant_user.phone_code,
      role: registrant_user.role,
      country_code: registrant_user.country_code,
      state: registrant_user.state,
      street: registrant_user.street,
      city: registrant_user.city,
      zip: registrant_user.zip,
      code: registrant_user.code,
    )
  end

  def contact_payload(user)
    {
      id: nil,
      name: user.name,
      email: user.email,
      phone: user.registrar_phone,
      ident: {
        ident: user.ident,
        ident_type: user.role,
        ident_country_code: 'EE',
      },
      addr: {
        country_code: 'EE',
        city: 'Tallinn',
        street: 'Street',
        zip: '13911',
        state: 'Harjumaa',
      },
      # addr: if Setting.show_address_customer
      #         {
      #           country_code: contact_params[:country_code],
      #           city: contact_params[:city],
      #           street: contact_params[:street],
      #           zip: contact_params[:zip],
      #           state: contact_params[:state],
      #         }
      #       end,
      # legal_document: transform_file_params(contact_params[:legal_document]),
    }
  end

  def transform_file_params(params)
    return if params.blank?

    { body: Base64.encode64(params.read),
      type: params.original_filename.split('.').last.downcase }
  end
end
