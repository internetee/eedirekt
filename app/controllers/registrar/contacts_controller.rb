module Registrar
  class ContactsController < ApplicationController
    before_action :load_contact, only: [:edit, :update, :destroy, :show]

    def index
      @pagy, @contacts = pagy(Contact.all.order(created_at: :desc), items: 15, link_extra: 'data-turbo-action="advance"')
    end

    def new
      @contact = Contact.new
    end

    def create
      @contact = Contact.new(contact_params)

      if @contact.save
        redirect_to registrar_contacts_path, status: :see_other, notice: t('.success')
      else
        flash[:alert] = @contact.errors.full_messages.join(', ')
        render 'dashboards/index', status: :unprocessable_entity
      end
    end

    def update
      if @contact.update(contact_params)
        redirect_to registrar_contacts_path, status: :see_other, notice: t('.success')
      else
        flash[:alert] = @contact.errors.full_messages.join(', ')
        render 'dashboards/index', status: :unprocessable_entity
      end
    end

    def destroy
      if @contact.destroy
        redirect_to registrar_contacts_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @contact.errors.inspect
        flash[:alert] = @contact.errors.full_messages.join(', ')
        render 'dashboards/index', status: :unprocessable_entity
      end
    end

    def search
      @contacts = Contact.search(params[:query])
      render json: @contacts.limit(5).map { |contact| { name: contact.name, ident: contact.ident, code: contact.code, id: contact.id } }
    end

    private

    def load_contact
      @contact = Contact.find_by(uuid: params[:uuid])
    end

    def contact_params
      params.require(:contact).permit(:code, :country_code, :ident,
                                      :role, :name, :email, :phone, :address_country_code,
                                      :city, :street, :state, :zip, :legal_document)
    end
  end
end
