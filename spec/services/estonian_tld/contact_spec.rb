require 'rails_helper'

LIMIT_VALUE = 10

RSpec.describe 'Services::EstonianTld::Contacts', type: :require do
  it 'should get dirty contact list from registry' do
    tld = Tld::Estonian.create(username: "oleghasjanov", password: "123456", base_url: "http://registry:3000")

    VCR.use_cassette('est_tld_registry_contact_list') do
      url_params = {
        details: true,
        limit: LIMIT_VALUE,
        offset: 0
      }

      dirty_contacs = EstonianTld::ContactService.new(tld:).contact_list(url_params:)
      expect(dirty_contacs['body']['data']['contacts'].count).to eq LIMIT_VALUE
    end
  end
end
