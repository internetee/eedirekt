module Registrar
  class DomainsController < ApplicationController
    def index
      @pagy, @domains = pagy(Domain.all.order(created_at: :desc), items: 15, link_extra: 'data-turbo-action="advance"')
    end

    def new
      @domain = Domain.new
      Tld::Estonian::MIN_NAMESERVER_COUNT.times do
        @domain.nameservers.build
      end
      Tld::Estonian::MIN_DOMAIN_CONTACT_COUNT.times do
        @domain.domain_contacts.build
      end

      @domain.dnssec_keys.build
    end

    def create
      domain_params_modified = domain_params.except(:period)
      domain_params_modified[:dnssec_keys_attributes].each do |dnssec_key_params|
        dnssec_key_params[:flags] = dnssec_key_params[:flags].to_i
        dnssec_key_params[:protocol] = dnssec_key_params[:protocol].to_i
        dnssec_key_params[:algorithm] = dnssec_key_params[:algorithm].to_i
      end

      @domain = Domain.new(domain_params_modified)
      period = params[:domain][:period].to_i
      @domain.expire_at = calculate_expiry(period)

      if @domain.save
        redirect_to root_path, notice: 'Domain was successfully created.'
      else
        Rails.logger.info @domain.errors.inspect
        flash[:alert] = @domain.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    end

    private

    def calculate_expiry(period)
      (Time.zone.now.advance(months: period) + 1.day).beginning_of_day
    end

    def domain_params
      params.require(:domain).permit(:name, :registrant_id, :period, :reserved_pw,
        domain_contacts_attributes: [:id, :contact_id, :type, :_destroy],
        nameservers_attributes: [:id, :hostname, :ipv4, :ipv6, :_destroy],
        dnssec_keys_attributes: [:id, :flags, :protocol, :algorithm, :public_key, :_destroy])
    end
  end
end
