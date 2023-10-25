module Form
  module PhoneInput
    class Component < ApplicationViewComponent
      attr_reader :form, :phone_attribute, :code_attribute, :code_placeholder,
                  :phone_placeholder, :code_data_attributes, :phone_data_attributes

      def initialize(form:, phone_attribute:, code_attribute:, **options)
        super

        @form = form
        @phone_attribute = phone_attribute
        @code_attribute = code_attribute
        @code_placeholder = options[:code_placeholder]
        @phone_placeholder = options[:phone_placeholder]
        @code_data_attributes = options[:code_data_attributes]
        @phone_data_attributes = options[:phone_data_attributes]
      end
    end
  end
end
