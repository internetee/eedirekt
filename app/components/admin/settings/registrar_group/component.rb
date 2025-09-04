module Admin
  module Settings
    module RegistrarGroup
      class Component < ApplicationViewComponent
        attr_reader :registrar_group, :form

        def initialize(registrar_group:, form:)
          @registrar_group = registrar_group
          @form = form
        end
      end
    end
  end
end
