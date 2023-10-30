require 'rails_helper'

RSpec.describe 'Serializers::EstonianTld::Contacts' do
  let(:dirty_contacts) do
    response = OpenStruct.new
    response.body = { 
      'data' => { 
        'contacts' => [
          {
            'code' => 'GIUFIHTLIQ:MBYGEWLUXY',
            'name' => 'KYPCFCAJWW',
            'ident' => { 'code' => '60001019906', 'type' => 'priv', 'country_code' => 'EE' },
            'phone' => '+372.59813111',
            'created_at' => '2023-04-25T11:21:52.897+03:00',
            'auth_info' => '30c562c2995db49db65a67',
            'email' => 'TLMNXGJWMR@KAPUDYMFRQ.ee',
            'statuses' => { 'ok' => '' },
            'disclosed_attributes' => [],
            'registrar' => { 'name' => 'NORM', 'website' => 'https://normal.ee' },
            'address' => { 'street' => 'IHSHGSWGTN', 'zip' => '12323', 'city' => 'QWKOZLJZBL', 'state_address' => nil,
                           'country_code' => 'EE' }
          },
          {
            'code' => 'FBEQKQBQTJ:LICFTAHLWV',
            'name' => 'GXLTYGIARK',
            'ident' => { 'code' => '60001019906', 'type' => 'priv', 'country_code' => 'EE' },
            'phone' => '+372.5981222',
            'created_at' => '2023-04-25T11:21:52.897+03:00',
            'updated_at' => '2023-04-26T11:21:52.897+03:00',
            'auth_info' => '30c562c2995db49db65a67',
            'email' => 'TLMNXGJWMR@KAPUDYMFRQ.ee',
            'statuses' => { 'ok' => '' },
            'disclosed_attributes' => [],
            'registrar' => { 'name' => 'NORM', 'website' => 'https://normal.ee' },
            'address' => { 'street' => 'IHSHGSWGTN', 'zip' => '12323', 'city' => 'QWKOZLJZBL', 'state_address' => nil,
                           'country_code' => 'EE' }
          }
        ] 
      } 
    }

    response
  end

  let(:clean_contact_struct) do
    information = {
      address: { 'street' => 'IHSHGSWGTN', 'zip' => '12323', 'city' => 'QWKOZLJZBL', 'state_address' => nil,
        'country_code' => 'EE' },
      statuses: { 'ok' => '' },
      registrar: { 'name' => 'NORM', 'website' => 'https://normal.ee' }
    }

    contact_struct = Struct.new(:name, :email, :phone, :ident, :code, :authInfo,
                                :role, :country_code, :information, :remote_updated_at, :state)
    contact_struct.new(
      'GXLTYGIARK', 'TLMNXGJWMR@KAPUDYMFRQ.ee', '+372.5981222', '60001019906', 'FBEQKQBQTJ:LICFTAHLWV',
      '30c562c2995db49db65a67', 'priv', 'EE', information, '2023-04-26T11:21:52.897+03:00', 1
    )
  end

  it 'should construct contact object from dirty data' do
    contacts = EstonianTld::ContactSerializer.call(dirty: dirty_contacts)

    expect(contacts.count).to eq 2
    contacts[1].information.delete(:metadata)

    puts '----'
    puts contacts[1].inspect
    puts '----'
    puts clean_contact_struct.inspect
    puts '-----'

    expect(contacts[1].to_s).to eq clean_contact_struct.to_s
  end
end
