module Registrar
  class PollMessagesController < ApplicationController
    include Roles::RegistrarAbilitable

    def index
      @tld = Tld.first
      all_notifications = EstonianTld::PollMessageService.new(tld: @tld).all_notifications
      @all_notifications = EstonianTld::NotificationSerializer.call(dirty: all_notifications)

      @pagy, @poll_messages = pagy_array(@all_notifications, items: 15, link_extra: 'data-turbo-action="advance"')
    end

    def update
      notification_id = params[:id]
      result = EstonianTld::PollMessageService.new(tld:).mark_as_read(notification_id)

      if result.success
        redirect_to root_path, notice: t('.success'), status: :see_other
      else
        flash[:alert] = t('.failure')
        render 'dashboards/index', status: :unprocessable_entity
      end
    end

    private

    def tld
      @tld ||= Tld.first
    end
  end
end
