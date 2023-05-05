require 'rails_helper'

RSpec.describe Registrar::ContactsController, type: :request do
  let(:registrar) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }
  crt_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.crt.pem"
  key_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.key.pem"

  let(:tld) { create(:tld) }

  let(:valid_attributes) do
    {
      code: 'example_code',
      country_code: 'EE',
      ident: 'example_ident',
      role: 'priv',
      name: 'example_name',
      email: 'example@example.com',
      phone: 'example_phone',
      address_country_code: 'EE',
      city: 'example_city',
      street: 'example_street',
      state: 'example_state',
      zip: 'example_zip'
      # legal_document: "example_legal_document"
    }
  end

  let(:invalid_attributes) do
    { email: 'invalid_email', country_code: 'Estonia' }
  end

  before(:each) do
    @tld = Tld::Estonian.create(username: 'oleghasjanov', password: '123456', base_url: 'http://registry:3000')
    @tld.crt.attach(fixture_file_upload(crt_file_path, 'application/x-x509-ca-cert'))
    @tld.key.attach(fixture_file_upload(key_file_path, 'application/x-x509-ca-cert'))

    @tld.reload && registrar.reload && super_user.reload
    registrar_login_basic_auth registrar
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Contact.create! valid_attributes
      get registrar_contacts_path

      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get new_registrar_contact_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Contact' do
        expect do
          post registrar_contacts_path, params: { contact: valid_attributes }
        end.to change(Contact, :count).by(1)
      end

      it 'redirects to the contacts list' do
        post registrar_contacts_path, params: { contact: valid_attributes }
        expect(response).to redirect_to(registrar_contacts_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Contact' do
        expect do
          post registrar_contacts_path, params: { contact: invalid_attributes }
        end.to change(Contact, :count).by(0)
      end
    end
  end

  # Добавьте остальные тесты для update и destroy, аналогично примерам выше
end
