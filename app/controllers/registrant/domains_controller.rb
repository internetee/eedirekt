module Registrant
  class DomainsController < ApplicationController
    include Roles::RegistrantAbilitable

    def new
      @domain = Domain.build_from_registrar(new)

      Tld::Estonian::MIN_NAMESERVER_COUNT.times do
        @domain.nameservers.build
      end
      Tld::Estonian::MIN_DOMAIN_CONTACT_COUNT.times do |i|
        i % 2 == 0 ? @domain.domain_contacts.build(type: 'AdminDomainContact') : @domain.domain_contacts.build(type: 'TechDomainContact')
      end

      @domain.dnssec_keys.build
    end

    def index; end

    def show; end

    def edit; end

    def create; end

    def update; end

    def destroy; end
  end
end