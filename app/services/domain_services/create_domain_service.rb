module DomainServices
  class CreateDomainService
    attr_reader :pending_action

    def initialize(pending_action)
      @pending_action = pending_action
    end

    def call
      # todo: check, do contacts exist in registry?
      # crete contacts if not
      # and after that run job
      

      EstonianTld::DomainCreationProcess::CreateDomainJob.perform_later(pending_action)
    end
  end
end
