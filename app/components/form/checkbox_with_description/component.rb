module Form
  module CheckboxWithDescription
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :label_name, :description, :value

      def initialize(form:, attribute:, label_name: nil, description: nil, value: false, **options)
        super

        @form = form
        @attribute = attribute
        @label_name = label_name
        @description = description
        @value = value
      end
    end
  end
end