class DashboardsController < ApplicationController
  def index
    @tld = Tld.first
    all_notifications = EstonianTld::PollMessageService.new(tld: @tld).all_notifications
    @all_notifications = EstonianTld::NotificationSerializer.call(dirty: all_notifications).first(5)
  end
end
