require 'rails_helper'

RSpec.describe EstonianTld::DomainsJob, type: :job do
  let(:contact1) { create(:contact) }
  let(:contact2) { create(:contact, ident: '60001019906') }
  let(:domain) { build(:domain) }

  let(:mock_domain_list) do
    OpenStruct.new(
      success: true,
      body: {
        'data' => {
          'count' => 2,
          'domains' => [
            {
              'name' => 'example1.ee',
              'updated_at' => '2023-01-01T12:00:00Z',
              'created_at' => '2020-01-01T12:00:00Z',
              'expire_time' => '2024-01-01T12:00:00Z',
              'statuses' => {
                'ok' => 'The domain is active and can be used'
              },
              'outzone_at' => '2024-02-01T12:00:00Z',
              'delete_date' => '2024-03-01T12:00:00Z',
              'force_delete_date' => '2024-04-01T12:00:00Z',
              'transfer_code' => 'ABC123',
              'dispute' => false,
              'registrant' => {
                'name' => "#{contact1.name}",
                'code' => "#{contact1.code}",
              },
              'nameservers' => [
                {
                  'hostname' => 'ns1.example1.ee',
                  'ipv4' => ['192.0.2.1'],
                  'ipv6' => ['2001:db8::1']
                },
                {
                  'hostname' => 'ns2.example1.ee',
                  'ipv4' => ['192.0.2.2'],
                  'ipv6' => ['2001:db8::2']
                }
              ],
              'dnssec_keys' => [
                {
                  'flags' => 257,
                  'protocol' => 3,
                  'alg' => 13,
                  'public_key' => 'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0tTUVTSU5HLS0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo='
                }
              ],
              'contacts' => [
                {
                  'code' => "#{contact1.code}",
                  'type' => 'AdminDomainContact',
                  'name' => "#{contact1.name}",
                },
                {
                  'code' => "#{contact2.code}",
                  'type' => 'TechDomainContact',
                  'name' => "#{contact2.name}",
                }
              ]
            }
          ]
        }
      }.with_indifferent_access
    )
  end

  before do
    @tld = Tld::Estonian.create(username: 'oleghasjanov', password: '123456', base_url: 'http://registry:3000')
    allow_any_instance_of(EstonianTld::DomainService).to receive(:domain_list).and_return(mock_domain_list)
  end

  it 'job should get domain list and save in db' do
    VCR.use_cassette('get_domain_list') do
      expect do
        described_class.perform_now(@tld)
      end.to change(Domain, :count).by(1)

      expect(Domain.find_by(name: 'example1.ee')).to be_present
    end
  end

  it 'does not perform synchronization if there are already domains in the database' do
    VCR.use_cassette('get_domain_list') do
      domain.name = 'example1.ee'
      domain.save! && domain.reload
      expect do
        described_class.perform_now(@tld)
      end.not_to change(Domain, :count)
    end
  end

  it 'handles errors when fetching the domain list' do
    error_response = OpenStruct.new(success: false, body: { code: 503, message: 'Error message', data: {} })
    allow_any_instance_of(EstonianTld::DomainService).to receive(:domain_list).and_return(error_response)

    expect(EstonianTld::InformAdminService).to receive(:call).with(hash_including(
      tld: Tld.first,
      message: a_string_including("Error fetching domains")
    ))

    expect do
      described_class.perform_now(@tld)
    end.not_to change(Domain, :count)
  end
end
