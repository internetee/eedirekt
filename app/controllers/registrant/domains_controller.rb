module Registrant
  class DomainsController < ApplicationController
    include Roles::RegistrantAbilitable

    def new
      @domain = Domain.new
    end

    def index
      pending_actions = current_user.pending_actions.order(created_at: :desc)
      @pagy, @pending_actions = pagy(pending_actions, items: 10, link_extra: 'data-turbo-action="advance"')

      @pagy_domain, @domains = pagy(current_user.domains.order(created_at: :desc), items: 10, link_extra: 'data-turbo-action="advance"')
    end

    def show; end

    def edit; end

    def create
      pending = PendingAction.create(
        user: current_user,
        action: :domain_create,
        status: :pending,
        info: domain_params.to_h,
      )

      @invoice = pending.create_invoice_by_pending_action

      if @invoice
        flash.now[:notice] = t('.success')

        render turbo_stream: [
          turbo_stream.append('flash', partial: 'layouts/flash'),
          turbo_stream.append('payment_method', partial: 'registrant/domains/payment_form',
                                               locals: {  })
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
      params.require(:domain).permit(:name, :period, :reserved_pw)
    end
  end
end