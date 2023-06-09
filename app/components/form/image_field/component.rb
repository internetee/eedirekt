module Form
  module ImageField
    class Component < ApplicationViewComponent
      attr_reader :label, :attribute, :form

      def initialize(label:, attribute:, form:)
        super

        @label = label
        @attribute = attribute
        @form = form
      end
    end
  end
end
