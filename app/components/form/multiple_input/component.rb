module Form
  module MultipleInput
    class Component < ApplicationViewComponent
      attr_reader :form, :collection, :attribute, :placeholder, :classes

      def initialize(form:, collection:, attribute:, classes: nil, placeholder: nil)
        super

        @form = form
        @collection = collection
        @attribute = attribute
        @placeholder = placeholder
        @classes = classes
      end
    end
  end
end
