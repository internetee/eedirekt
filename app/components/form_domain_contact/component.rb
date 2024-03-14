module FormDomainContact
  class Component < ApplicationViewComponent
    attr_reader :contact_type, :form, :domain

    def initialize(contact_type:, form:, domain:, **options)
      super

      @contact_type = contact_type
      @form = form
      @domain = domain
    end

    def label_name
      form.label "#{contact_type}_contact_attributes_name", contact_type
    end

    def constanicize_contact_type
      contact_type.to_s.camelize.constantize
    end

    def contact_type_objects
      "#{contact_type}s"
    end
  end
end