module Form
  module CountrySelectInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :heroicon_name

      def initialize(form:, attribute:, heroicon_name: nil, **options)
        @form = form
        @attribute = attribute
        @heroicon_name = heroicon_name
      end
    end
  end
end