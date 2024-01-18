module Registrant
  class DomainsController < ApplicationController
    include Roles::RegistrantAbilitable

    def new
      @domain = Domain.new
    end

    def index
      @pending_actions = current_user.pending_actions
    end

    def show; end

    def edit; end

    def create
      # result = current_api_adapter.create_domain(payload: params[:domain])

      # if result.success?
      #   redirect_to registrant_domains_path, notice: t('.success')
      # else
      #   @domain = Domain.build_from_registrar(params[:domain])
      #   flash.now[:alert] = result.errors
      #   render :new
      # end

      # ==============
      # TODO:
      # + Create pending action "Create Domain" (Table i created)
      # + If user not in contact list or he doesn't have a code, create contact with code (I implement this jov)
      # + Generate Invoice for this action (Need implement this method in PendingAction model)
      # + User pay and he redirected back (I created oneoff service object)
      
      # SHow banner that domain is creating (Need to implement)
      # Create domain and Send this info to EPP (implement this job)

      pending = PendingAction.create(
        user: current_user,
        action: :domain_create,
        status: :pending,
        info: {
          domain: params[:name],
          reserved_pw: params[:reserved_pw],
          period: params[:period],
         },
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
  end
end