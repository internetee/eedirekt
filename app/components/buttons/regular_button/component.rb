module Buttons
  module RegularButton
    class Component < ViewComponent::Base
      attr_reader :text, :path, :method, :classes, :data, :form_data

      def initialize(text:, path:, method: :post, **options)
        @text = text
        @path = path
        @method = method
        @classes = options[:classes]
        @data = options[:data]
        @form_data = options[:form_data]
      end

    end
  end
end