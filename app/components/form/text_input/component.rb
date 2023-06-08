module Form
  module TextInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :heroicon_name, :placeholder

      def initialize(form:, attribute:, heroicon_name:, placeholder: nil, **options)
        @form = form
        @attribute = attribute
        @heroicon_name = heroicon_name
        @placeholder = placeholder
      end
    end
  end
end