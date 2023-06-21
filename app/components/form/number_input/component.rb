module Form
  module NumberInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :heroicon_name, :placeholder, :data_attributes, :min, :max, :value

      def initialize(form:, attribute:, heroicon_name:, placeholder: nil, **options)
        @form = form
        @attribute = attribute
        @heroicon_name = heroicon_name
        @placeholder = placeholder
        @data_attributes = options[:data_attributes]
        @min = options[:min]
        @max = options[:max]
        @value = options[:value]
      end
    end
  end
end