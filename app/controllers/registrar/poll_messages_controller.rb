module Registrar
  class PollMessagesController < ApplicationController
    include Roles::RegistrarAbilitable
    before_action :notifications

    def index; end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def update
      result = EstonianTld::PollMessageService.new(tld:).mark_as_read(params[:id])

      if result.success
        flash.now[:notice] = t('.success')
        render turbo_stream: [
          turbo_stream.replace('flash', partial: 'layouts/flash'),
          turbo_stream.poll_message_mark_as_read("poll_message_#{params[:id]}", item_id: params[:id]),
          turbo_stream.append('poll_messages', partial: 'registrar/poll_messages/poll_message', locals: { poll_message: @poll_messages.last })
        ]
      else
        flash[:alert] = t('.failure')
        render 'dashboards/index', status: :unprocessable_entity
      end
    end

    def notifications
      all_notifications = EstonianTld::PollMessageService.new(tld: @tld).all_notifications
      @all_notifications = EstonianTld::NotificationSerializer.call(dirty: all_notifications)

      @pagy, @poll_messages = pagy_array(@all_notifications, items: 15, link_extra: 'data-turbo-action="advance"')
    end
  end
end
