module Registrar
  class DomainsController < ApplicationController
    def index
      @pagy, @domains = pagy(Domain.all.order(created_at: :desc), items: 15, link_extra: 'data-turbo-action="advance"')
    end

    def new
      @domain = Domain.new
    end

    def create
      p '----------'
      p params
      p '----------'
    end
  end
end
