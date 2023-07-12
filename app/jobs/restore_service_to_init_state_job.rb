class RestoreServiceToInitStateJob < ApplicationJob
  queue_as :default

  def perform
    return unless Rails.env.development? || Rails.env.test? || Rails.env.staging?

    Tld.destroy_all
    SuperUser.destroy_all
    Contact.destroy_all
    Domain.destroy_all
    Invoice.destroy_all
    User.destroy_all
  end
end
