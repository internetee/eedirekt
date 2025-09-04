module Admin
  module Settings
    module ContactGroup
      class Component < ApplicationViewComponent
        attr_reader :contact_group, :form

        def initialize(contact_group:, form:)
          @contact_group = contact_group
          @form = form
        end
      end
    end
  end
end
