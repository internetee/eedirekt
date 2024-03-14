module DomainServices
  class CreateDomainService
    attr_reader :pending_action

    def initialize(pending_action)
      @pending_action = pending_action
    end

    def call
      EstonianTld::DomainCreationProcess::CreateContactsJob.perform_later(pending_action)
      # EstonianTld::DomainCreationProcess::CreateDomainJob.perform_later(pending_action)
    end
  end
end
