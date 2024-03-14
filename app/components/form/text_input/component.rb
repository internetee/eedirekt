module Form
  module TextInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :heroicon_name, :placeholder, :data_attributes, :readonly

      def initialize(form:, attribute:, heroicon_name:, placeholder: nil, options: {})
        @form = form
        @attribute = attribute
        @heroicon_name = heroicon_name
        @placeholder = placeholder
        @data_attributes = options[:data_attributes]
        @options = options
        # @readonly = options[:readonly] || false
      end
    end
  end
end