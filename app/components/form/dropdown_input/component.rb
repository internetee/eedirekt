module Form
  module DropdownInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :enum, :heroicon_name

      def initialize(form:, attribute:, enum:, heroicon_name:, **options)
        @form = form
        @attribute = attribute
        @enum = enum
        @heroicon_name = heroicon_name
      end
    end
  end
end