module Common
  module StatusesInfo
    class Component < ViewComponent::Base

      attr_reader :status_notes, :statuses

      def initialize(status_notes:, statuses:, **options)
        super

        @statuses = statuses
        @status_notes = status_notes
      end
    end
  end
end
