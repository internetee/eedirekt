module Admin
  module Settings
    module InvoiceGroup
      class Component < ApplicationViewComponent
        attr_reader :invoice_group, :form

        def initialize(invoice_group:, form:)
          @invoice_group = invoice_group
          @form = form
        end
      end
    end
  end
end
