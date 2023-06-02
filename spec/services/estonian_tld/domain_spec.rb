require 'rails_helper'

LIMIT_VALUE = 10

RSpec.describe 'Services::EstonianTld::Domains', type: :require do
  it 'should get dirty domain list from registry' do
    tld = Tld::Estonian.create(username: "oleghasjanov", password: "123456", base_url: "http://registry:3000")

    VCR.use_cassette('est_tld_registry_domain_list') do
      url_params = {
        details: true,
        limit: LIMIT_VALUE,
        offset: 0
      }

      dirty_domains = EstonianTld::DomainService.new(tld: tld).domain_list(url_params: url_params)
      expect(dirty_domains['body']['data']['domains'].count).to eq LIMIT_VALUE
    end
  end
end
