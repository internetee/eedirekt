module Form
  module SearchInput
    class Component < ApplicationViewComponent
      attr_accessor :attr, :form, :placeholder, :label_name, :options

      def initialize(form:, placeholder:, label_name:, attr:, options: {})
        super

        @attr = attr
        @form = form
        @placeholder = placeholder
        @label_name = label_name
        @options = options
      end
    end
  end
end
