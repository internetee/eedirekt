class EstonianReppAdapter
  include AdapterInterface

  def create_domain(domain:, pending_action:)
    EstonianTld::DomainService.new(tld: Tld.first).create(domain, pending_action)
  end
end
