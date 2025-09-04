module Settings
  module HashField
    class Component < ApplicationViewComponent
      attr_reader :setting, :form

      def initialize(setting:, form:)
        @setting = setting
        @form = form
        @parsed_value = eval(setting.value)
      end
    end
  end
end
