class EstonianReppAdapter
  include AdapterInterface

  def create_domain(payload:)
    EstonianTld::DomainService.new(tld: Tld.first).create(payload:)
  end
end
