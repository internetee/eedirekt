class DashboardsController < ApplicationController
  def index
    @tld = Tld.first

    return unless current_user&.class&.name == 'RegistrarUser'

    all_notifications = EstonianTld::PollMessageService.new(tld: @tld).all_notifications
    @all_notifications = if all_notifications.present?
                           EstonianTld::NotificationSerializer.call(dirty: all_notifications).first(5)
                         else
                           []
                         end
  end
end
