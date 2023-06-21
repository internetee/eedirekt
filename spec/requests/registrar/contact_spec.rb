require 'rails_helper'

RSpec.describe Registrar::ContactsController, type: :request do
  let(:registrar_user) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }

  let(:tld) { create(:tld) }
  let(:contact) { create(:contact) }

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
      zip: 'example_zip',
      # legal_document: "example_legal_document"
    }
  end

  before(:each) do
    @tld = Tld::Estonian.create(username: 'oleghasjanov', password: '123456', base_url: 'http://registry:3000')
    @tld.reload && registrar_user.reload && super_user.reload
    registrar_login_basic_auth registrar_user
  end

  it_behaves_like 'registrar_permissions',
                    value: lambda {
                             { admin: super_user, registrar: registrar_user,
                               options: [
                                {
                                  method: :get,
                                  path: registrar_contacts_path,
                                },
                                {
                                  method: :get,
                                  path: registrar_contact_path(uuid: contact.uuid),
                                },
                                {
                                  method: :get,
                                  path: edit_registrar_contact_path(uuid: contact.uuid),
                                },
                                {
                                  method: :get,
                                  path: new_registrar_contact_path,
                                },
                                {
                                  method: :post,
                                  path: registrar_contacts_path,
                                  payload: {
                                   contact: valid_attributes
                                 }
                                },
                                {
                                  method: :patch,
                                  path: registrar_contact_path(uuid: contact.uuid),
                                  payload: {
                                    contact: {
                                      name: Faker::Name.name.gsub(' ', '_').underscore,
                                    }
                                  }
                                },
                                {
                                  method: :delete,
                                  path: registrar_contact_path(uuid: contact.uuid),
                                },
                               ]
                              }
                           }


  let(:invalid_attributes) do
    { email: 'invalid_email', country_code: 'Estonia' }
  end

  describe 'POST #create' do
    context 'with invalid params' do
      it 'does not create a new Contact' do
        expect do
          post registrar_contacts_path, params: { contact: invalid_attributes }
        end.to change(Contact, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with invalid params' do
      it 'does not update the contact' do
        contact = Contact.create! valid_attributes
        contact.reload

        patch registrar_contact_path(uuid: contact.uuid), params: { contact: invalid_attributes }
        expect(contact.reload.email).not_to eq(invalid_attributes[:email])
      end
    end
  end
end
