module Registrars
  module ContactsHelper
    def show_address?
      Setting.show_address_customer
    end
  end
end
