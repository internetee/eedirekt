module Form
  module DropdownInput
    class Component < ApplicationViewComponent
      attr_reader :form, :attribute, :enum, :heroicon_name, :include_blank

      def initialize(form:, attribute:, enum:, heroicon_name:, **options)
        super

        @form = form
        @attribute = attribute
        @enum = enum
        @heroicon_name = heroicon_name
        @include_blank = options.fetch(:include_blank, true)
      end
    end
  end
end