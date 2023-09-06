module Registrar
  module PollMessages
    class DequeuesController < ApplicationController
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def update
        result = EstonianTld::PollMessageService.new(tld:).mark_as_read(params[:poll_message_id])

        if result.success

          data = EstonianTld::SummaryService.call(tld: @tld)
          struct_data = EstonianTld::SummarySerializer.call(dirty: data)
          @notification = struct_data[:notification]
          @notifications_count = struct_data[:notifications_count]

          flash.now[:notice] = t('.success')
          render turbo_stream: [
            turbo_stream.append('flash', partial: 'layouts/flash'),

            # TODO: This is not working. Need to fix animation playing before execute another turbo actions.
            # turbo_stream.poll_message_dequeue('message-box', element_id: 'message-box'),

            turbo_stream.update('notification-header',
                                html: "#{t('dashboards.notifications.notification_title')} (#{@notifications_count})"),
            if @notification
              turbo_stream.append('dashboard-notification', partial: 'dashboards/notifications/message',
                                                            locals: { notification: @notification })
            else
              turbo_stream.append('dashboard-notification', partial: 'dashboards/notifications/no_message')
            end
          ]
        else
          flash[:alert] = t('.failure')
          render turbo_stream: [
            turbo_stream.append('flash', partial: 'layouts/flash')
          ]
        end
      end
    end
  end
end
