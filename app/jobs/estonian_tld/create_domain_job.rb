class EstonianTld::CreateDomainJob < ApplicationJob
  queue_as :critical

  def perform(domain)
    # TODO: Create domain in local database and send by EPP to registry
  end
end