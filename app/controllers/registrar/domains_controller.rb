module Registrar
  class DomainsController < ApplicationController
    include Roles::RegistrarAbilitable

    before_action :load_domain, only: %i[show edit update destroy]

    def index
      @pagy, @domains = pagy(Domain.search(params), items: 15, link_extra: 'data-turbo-action="advance"')
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
      @domain = Domain.new(domain_params_modified)
      period = params[:domain][:period].to_i
      @domain.expire_at = calculate_expiry(period)

      if @domain.save
        redirect_to root_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @domain.errors.inspect
        flash[:alert] = @domain.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    end

    def show; end

    def edit; end

    def update
      domain_params_modified = domain_params.except(:period)
      period = params[:domain][:period].to_i
      domain_params_modified[:expire_at] = calculate_expiry(period)

      if @domain.update(domain_params_modified)
        redirect_to registrar_domains_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @domain.errors.inspect
        flash[:alert] = @domain.errors.full_messages.join(', ')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @domain.destroy
        redirect_to registrar_domains_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @domain.errors.inspect
        flash[:alert] = @domain.errors.full_messages.join(', ')
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def load_domain
      @domain = Domain.find_by(uuid: params[:uuid])
    end

    def calculate_expiry(period)
      (Time.zone.now.advance(months: period) + 1.day).beginning_of_day
    end

    def domain_params
      params.require(:domain).permit(:name, :registrant_id, :period, :reserved_pw,
                                     domain_contacts_attributes: %i[id contact_id type _destroy],
                                     nameservers_attributes: %i[id hostname ipv4 ipv6 _destroy],
                                     dnssec_keys_attributes: %i[id flags protocol algorithm public_key _destroy])
    end
  end
end
