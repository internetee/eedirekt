module Admin
  module Contacts
    class SearchesController < ApplicationController
      include Roles::AdminAbilitable

      def show
        puts '----'
        puts params[:query]
        puts '-----'

        @contacts = Contact.search(params[:query])

        puts '==== contacts'
        puts @contacts.inspect
        puts '====='

        render json: @contacts.limit(5).map(&:as_json)
      end
    end
  end
end
