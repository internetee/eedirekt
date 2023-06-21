module Form
  module TextareaInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :data_attributes

      def initialize(form:, attribute:, **options)
        @form = form
        @attribute = attribute
        @data_attributes = options[:data_attributes]
      end
    end
  end
end