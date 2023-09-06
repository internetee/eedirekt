class DashboardsController < ApplicationController
  def index
    @tld = Tld.first

    return unless current_user&.class&.name == 'RegistrarUser'

    data = EstonianTld::SummaryService.call(tld: @tld)
    struct_data = EstonianTld::SummarySerializer.call(dirty: data)

    @notification = struct_data[:notification]
    @notifications_count = struct_data[:notifications_count]
    @username = struct_data[:username]
    @balance = struct_data[:balance]
    @domains_count = struct_data[:domains_count]
    @contacts_count = struct_data[:contacts_count]
    @last_login_date = struct_data[:last_login_date]
  end
end
