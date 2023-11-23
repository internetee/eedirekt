class DashboardsController < ApplicationController
  def index
    @tld = Tld.first

    if current_user&.class&.name == 'RegistrarUser'
      data = EstonianTld::SummaryService.call(tld: @tld)
      struct_data = EstonianTld::SummarySerializer.call(dirty: data)

      @notification = struct_data[:notification]
      @notifications_count = struct_data[:notifications_count]
      @username = struct_data[:username]
      @balance = struct_data[:balance]
      @registry_domains_count = struct_data[:domains_count]
      @domains_count = Domain.count
      @contacts_count = struct_data[:contacts_count]
      @last_login_date = struct_data[:last_login_date]
    elsif current_user&.class&.name == 'User'
      contact = Contact.find_by(ident: current_user.code)
      @domains = contact&.domains
    end
  end
end
