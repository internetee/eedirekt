module Registrar
  class ContactsController < ApplicationController
    include Roles::RegistrarAbilitable

    before_action :load_contact, only: %i[edit update destroy show]

    def index
      @pagy, @contacts = pagy(Contact.search_filter(params).distinct, items: 15, link_extra: 'data-turbo-action="advance"')
    end

    def new
      @contact = Contact.new
    end

    def show; end

    def create
      @contact = Contact.new(contact_params)

      if @contact.save
        redirect_to registrar_contacts_path, status: :see_other, notice: t('.success')
      else
        flash[:alert] = @contact.errors.full_messages.join(', ')
        render 'registrar/contacts/new', status: :unprocessable_entity
      end
    end

    def update
      if @contact.update(contact_params)
        redirect_to registrar_contacts_path, status: :see_other, notice: t('.success')
      else
        flash[:alert] = @contact.errors.full_messages.join(', ')
        render 'registrar/contacts/edit', status: :unprocessable_entity
      end
    end

    def destroy
      if @contact.destroy
        redirect_to registrar_contacts_path, status: :see_other, notice: t('.success')
      else
        Rails.logger.info @contact.errors.inspect
        flash[:alert] = @contact.errors.full_messages.join(', ')
        render 'registrar/contacts/index', status: :unprocessable_entity
      end
    end

    def search
      puts '----'
      puts params[:query]
      puts '-----'

      @contacts = Contact.search(params[:query])

      puts '==== contacts'
      puts @contacts.inspect
      puts '====='

      render json: @contacts.limit(5).map(&:as_json)
    end

    private

    def load_contact
      @contact = Contact.find_by(uuid: params[:uuid])
    end

    def contact_params
      params.require(:contact).permit(:code, :country_code, :ident, :phone_code,
                                      :role, :name, :email, :phone, :address_country_code,
                                      :city, :street, :state, :zip, :legal_document)
    end
  end
end
