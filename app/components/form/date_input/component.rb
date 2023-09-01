module Form
  module DateInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :heroicon_name, :placeholder, :data_attributes

      def initialize(form:, attribute:, heroicon_name:, placeholder: nil, **options)
        super

        @form = form
        @attribute = attribute
        @heroicon_name = heroicon_name
        @placeholder = placeholder
        @data_attributes = options[:data_attributes]
      end
    end
  end
end