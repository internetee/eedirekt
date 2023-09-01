module Lists
  module BasicList
    class Component < ApplicationViewComponent
      attr_reader :collection

      def initialize(collection:)
        super

        @collection = collection
      end

      def recognize_item_path(item)
        case item.class.name.underscore
        when 'contact'
          registrar_contact_path(item.uuid)
        when 'domain'
          registrar_domain_path(item.uuid)
        end
      end
    end
  end
end
