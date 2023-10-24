module Contacts
  module Info
    class Component < ViewComponent::Base
      include ::Registrars::ContactsHelper

      attr_reader :contact

      def initialize(contact:, **options)
        super

        @contact = contact
      end
    end
  end
end
