module Settings
  module ArrayField
    class Component < ApplicationViewComponent
      attr_reader :setting, :form

      def initialize(setting:, form:)
        @setting = setting
        @form = form
        @parsed_data = eval(setting.value)
      end
    end
  end
end
