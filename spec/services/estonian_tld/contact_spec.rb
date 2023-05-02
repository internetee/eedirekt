require 'rails_helper'

LIMIT_VALUE = 10

RSpec.describe 'Services::EstonianTld::Contacts', type: :require do
  crt_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.crt.pem"
  key_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.key.pem"

  it 'should get dirty contact list from registry' do
    tld = Tld::Estonian.create(username: "oleghasjanov", password: "123456", base_url: "http://registry:3000")
    tld.crt.attach(fixture_file_upload(crt_file_path, 'application/x-x509-ca-cert'))
    tld.key.attach(fixture_file_upload(key_file_path, 'application/x-x509-ca-cert'))

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
