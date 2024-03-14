module Registrant
  class DomainsController < ApplicationController
    include Roles::RegistrantAbilitable

    def new
      @domain = Domain.new

      Tld::Estonian::MIN_DOMAIN_CONTACT_COUNT.times do |i|
        admin_contact = Contact.find_by(code: current_user.code)
        tech_contact = Contact.find_by(code: Setting.code_of_technical_contact)

        if i % 2 == 0
          @domain.admin_domain_contacts.build(contact: admin_contact)
        else
          @domain.tech_domain_contacts.build(contact: tech_contact)
        end

      end

      Tld::Estonian::MIN_NAMESERVER_COUNT.times do |i|
        current_nameserver = JSON.parse(Setting.default_nameserver_records[i])
        @domain.nameservers.build(
          hostname: current_nameserver['hostname'],
          ipv4: current_nameserver['ipv4'],
          ipv6: current_nameserver['ipv6']
        )
      end

      @domain.dnssec_keys.build(
        flags: Setting.dnssec_default_value['flags'],
        protocol: Setting.dnssec_default_value['protocol'],
        algorithm: Setting.dnssec_default_value['algorithm'],
        public_key: Setting.dnssec_default_value['public_key']
      )
    end

    def index
      pending_actions = current_user.pending_actions.order(created_at: :desc)
      @pagy, @pending_actions = pagy(pending_actions, items: 10, link_extra: 'data-turbo-action="advance"')

      if current_user.domains.present?
        @pagy_domain, @domains = pagy(current_user.domains.order(created_at: :desc), items: 10, link_extra: 'data-turbo-action="advance"')
      else
        @pagy_domain, @domains = pagy(Domain.none, items: 10, link_extra: 'data-turbo-action="advance"')
      end
    end

    def show; end

    def edit; end

    def create
      # TODO: Need to add validation for ident of contacts, email and other attributes

      domain_price = DomainPrice.find(domain_params[:domain_price])

      pending = PendingAction.create(
        user: current_user,
        action: :domain_create,
        status: :pending,
        info: domain_params.to_h.merge(
          period: domain_price.months,
          domain_price: domain_price.attributes
        )
      )

      @invoice = pending.create_invoice_by_pending_action(domain_price.price.to_f)

      if @invoice
        flash.now[:notice] = t('.success')

        render turbo_stream: [
          turbo_stream.append('flash', partial: 'layouts/flash'),
          turbo_stream.append('payment_method', partial: 'registrant/domains/payment_form',
                                               locals: { invoice: @invoice})
        ]
      else
        flash[:alert] = @invoice.errors.full_messages
        render turbo_stream: turbo_stream.replace('flash', partial: 'layouts/flash')
      end
    end

    def update; end

    def destroy; end

    private

    def domain_params
      params.require(:domain).permit(
        :name, 
        :period, 
        :reserved_pw, 
        :domain_price,
        tech_domain_contacts_attributes: [
          :id, 
          :_destroy, 
          contact: [:role, :name, :email, :ident, :country_code, :_destroy, :phone, :phone_code, :state, :street, :city, :zip, :address_country_code]
        ],
        admin_domain_contacts_attributes: [
          :id, 
          :_destroy, 
          contact: [:role, :name, :email, :ident, :_destroy, :country_code, :phone, :phone_code, :state, :street, :city, :zip, :address_country_code]
        ],
        nameservers_attributes: [
          :id,
          :hostname,
          :ipv4,
          :ipv6,
          :_destroy
        ],
        dnssec_keys_attributes: [
          :id,
          :flags,
          :protocol,
          :algorithm,
          :public_key,
          :_destroy
        ]
      )
    end
  end
end