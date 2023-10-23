module Form
  module DateInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :heroicon_name, :placeholder, :data_attributes, :label_name, :value

      def initialize(form:, attribute:, heroicon_name:, placeholder: nil, label_name: nil, value: nil, **options)
        super

        @form = form
        @attribute = attribute
        @label_name = label_name
        @heroicon_name = heroicon_name
        @placeholder = placeholder
        @value = value
        @data_attributes = options[:data_attributes]
      end
    end
  end
end