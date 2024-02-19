module Registrant
  class ContactsController < ApplicationController
    include Roles::RegistrantAbilitable

    def new
      @contact = Contact.new
    end

    def create
    end

    def search
      @contacts = Contact.where('ident ILIKE ?', "%#{params[:query]}%")

      render json: @contacts.limit(5).map(&:as_json)
    end
  end
end