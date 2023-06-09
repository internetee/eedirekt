module Divider
    class Component < ViewComponent::Base
      attr_reader :label

      def initialize(label:, **options)
        super

        @label = label
      end
    end
end