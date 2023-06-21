module Registrar
  class InvoicesController < ApplicationController
    include Roles::RegistrarAbilitable

    before_action :load_invoice, only: %i[show edit update destroy]

    def index
      @pagy, @invoices = pagy(Invoice.all.order(created_at: :desc), items: 15, link_extra: 'data-turbo-action="advance"')
    end

    def show; end

    def new
      @invoice = Invoice.new
      @invoice.invoice_items.build
    end

    def create
      @invoice = Invoice.new(invoice_params)

      if @invoice.save
        redirect_to registrar_invoices_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @invoice.errors.inspect
        flash[:alert] = @invoice.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
       p '---------'
      if @invoice.update(invoice_params)
        redirect_to registrar_invoices_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @invoice.errors.inspect
        flash[:alert] = @invoice.errors.full_messages.join(', ')
        render :edit, status: :unprocessable_entit
      end
    end

    def destroy
      if @invoice.destroy
        redirect_to registrar_invoices_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @invoice.errors.inspect
        flash[:alert] = @invoice.errors.full_messages.join(', ')
        render :index, status: :unprocessable_entit
      end
    end

    private

    def load_invoice
      @invoice = Invoice.find_by(uuid: params[:uuid])
    end

    def invoice_params
      params.require(:invoice).permit(:buyer_id, :name, :country_code, :state, :street, :city, :zip, :phone, :url, :status,
                                      :email, :description, :invoice_items_attributes => [:id, :unit_price, :quantity, :description, :_destroy] )
    end
  end
end
