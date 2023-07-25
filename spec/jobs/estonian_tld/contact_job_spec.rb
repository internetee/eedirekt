require 'rails_helper'

RSpec.describe EstonianTld::ContactsJob, type: :job do
  let(:mock_contact_list) do
    OpenStruct.new(
      success: true,
      body: {
        'data' => {
          'count' => 2,
          'contacts' => [
            {
              'name' => 'John Doe',
              'email' => 'john@example.com',
              'phone' => '123456789',
              'country_code' => 'US',
              'ident' => { 'code' => '1', 'type' => 'priv', 'country_code' => 'US' },
              'code' => '123',
              'auth_info' => 'secret',
              'updated_at' => '2023-01-01T00:00:00Z'
            },
            {
              'name' => 'Jane Doe',
              'email' => 'jane@example.com',
              'phone' => '987654321',
              'country_code' => 'US',
              'ident' => { 'code' => '2', 'type' => 'priv', 'country_code' => 'US' },
              'code' => '456',
              'auth_info' => 'top_secret',
              'updated_at' => '2023-01-01T00:00:00Z'
            }
          ]
        }
      }.with_indifferent_access
    )
  end

  before do
    @tld = Tld::Estonian.create(username: 'oleghasjanov', password: '123456', base_url: 'http://registry:3000')

    allow_any_instance_of(EstonianTld::ContactService).to receive(:contact_list).and_return(mock_contact_list)
  end

  it 'job should get contact list and save in db' do
    VCR.use_cassette('get_contact_list') do
      expect do
        described_class.perform_now(@tld)
      end.to change(Contact, :count).by(2)

      expect(Contact.find_by(email: 'john@example.com')).to be_present
      expect(Contact.find_by(email: 'jane@example.com')).to be_present
    end
  end

  # TODO:
  # Temporary disabled - not decided yet do this feature is needed or not

  # it 'does not perform synchronization if there are already contacts in the database' do
  #   Contact.create!(email: 'existing@example.com', name: 'Existing Contact')

  #   expect do
  #     described_class.perform_now(@tld)
  #   end.not_to change(Contact, :count)
  # end

  it 'handles errors when fetching the contact list' do
    VCR.use_cassette('error_when_fetching_the_contact_list') do
      error_response = OpenStruct.new(success: false, body: { code: 503, message: 'Error message', data: {} })
      allow_any_instance_of(EstonianTld::ContactService).to receive(:contact_list).and_return(error_response)

      expect(EstonianTld::InformAdminService).to receive(:call).with(hash_including(
        tld: Tld.first,
        message: a_string_including("Error fetching contacts")
      ))

      expect do
        described_class.perform_now(@tld)
      end.not_to change(Contact, :count)
    end
  end

  # Comment out because jobs temporary runs without delayed
  # it 'calls EstonianTld::DomainsJob after performing the contacts job' do
  #   VCR.use_cassette('call_domains_job') do
  #     expect(EstonianTld::DomainsJob).to receive(:perform_later).with(Tld.first)

  #     described_class.perform_now(@tld)
  #   end
  # end
end
