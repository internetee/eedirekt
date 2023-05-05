require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validations' do
    it 'should be valid with valid country_code and address_country_code' do
      contact = Contact.new(country_code: 'US', address_country_code: 'US')
      expect(contact).to be_valid
    end

    it 'should be valid with null country_code and address_country_code' do
      contact = Contact.new(country_code: nil, address_country_code: nil)
      expect(contact).to be_valid
    end

    it 'should be invalid with invalid country_code' do
      contact = Contact.new(country_code: 'INVALID', address_country_code: 'US')
      expect(contact).not_to be_valid
      expect(contact.errors[:country_code]).to include('должен быть действительным кодом страны в формате alpha2')
    end

    it 'should be invalid with invalid address_country_code' do
      contact = Contact.new(country_code: 'US', address_country_code: 'INVALID')
      expect(contact).not_to be_valid
      expect(contact.errors[:address_country_code]).to include('должен быть действительным кодом страны в формате alpha2')
    end
  end

  describe 'associations' do
    it { should have_many(:domain_contacts) }
    it { should have_many(:domains).through(:domain_contacts) }
  end

  describe 'address and registrar methods' do
    let(:contact) do
      Contact.new(
        address: { 'zip' => '12345', 'city' => 'New York', 'state' => 'NY', 'street' => '123 Main St',
                   'country_code' => 'US' },
        registrar: { 'name' => 'Example Registrar', 'website' => 'https://www.example.com' }
      )
    end

    it 'should handle zip getter and setter' do
      expect(contact.zip).to eq('12345')
      contact.zip = '67890'
      expect(contact.zip).to eq('67890')
    end

    it 'should handle city getter and setter' do
      expect(contact.city).to eq('New York')
      contact.city = 'San Francisco'
      expect(contact.city).to eq('San Francisco')
    end

    it 'should handle state getter and setter' do
      expect(contact.state).to eq('NY')
      contact.state = 'CA'
      expect(contact.state).to eq('CA')
    end

    it 'should handle street getter and setter' do
      expect(contact.street).to eq('123 Main St')
      contact.street = '456 Market St'
      expect(contact.street).to eq('456 Market St')
    end

    it 'should handle address_country_code getter and setter' do
      expect(contact.address_country_code).to eq('US')
      contact.address_country_code = 'GB'
      expect(contact.address_country_code).to eq('GB')
    end

    it 'should handle registrar_name getter and setter' do
      expect(contact.registrar_name).to eq('Example Registrar')
      contact.registrar_name = 'New Registrar'
      expect(contact.registrar_name).to eq('New Registrar')
    end

    it 'should handle registrar_website getter and setter' do
      expect(contact.registrar_website).to eq('https://www.example.com')
      contact.registrar_website = 'https://www.new-registrar.com'
      expect(contact.registrar_website).to eq('https://www.new-registrar.com')
    end
  end

  describe 'included modules' do
    it 'should include Contact::EstTld::Roles module' do
      expect(Contact.ancestors).to include(Contact::EstTld::Roles)
    end
  
    it 'should include Contact::EstTld::Country module' do
      expect(Contact.ancestors).to include(Contact::EstTld::Country)
    end
  end  
end
