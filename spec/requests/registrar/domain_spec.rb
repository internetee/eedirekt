require 'rails_helper'

RSpec.describe Registrar::DomainsController, type: :request do
  let(:registrar) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }
  crt_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.crt.pem"
  key_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.key.pem"

  let(:tld) { create(:tld) }
  let(:registrant) { create(:contact) }

  before(:each) do
    @tld = Tld::Estonian.create(username: 'oleghasjanov', password: '123456', base_url: 'http://registry:3000')
    @tld.crt.attach(fixture_file_upload(crt_file_path, 'application/x-x509-ca-cert'))
    @tld.key.attach(fixture_file_upload(key_file_path, 'application/x-x509-ca-cert'))

    @tld.reload && registrar.reload && super_user.reload
    registrar_login_basic_auth registrar
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get registrar_domains_path
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get new_registrar_domain_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          domain: {
            name: 'example.com',
            registrant_id: registrant.id,
            period: 1,
            reserved_pw: 'password',
            domain_contacts_attributes: [
              {
                contact_id: create(:contact).id,
                type: 'AdminDomainContact'
              },
              {
                contact_id: create(:contact).id,
                type: 'TechDomainContact'
              }
            ],
            nameservers_attributes: [
              {
                hostname: 'ns1.example.com',
                ipv4: '192.0.2.1',
                ipv6: '2001:db8::1'
              },
              {
                hostname: 'ns2.example.com',
                ipv4: '192.0.2.2',
                ipv6: '2001:db8::2'
              }
            ],
            dnssec_keys_attributes: [
              {
                flags: '256',
                protocol: '3',
                algorithm: '13',
                public_key: 'public_key'
              }
            ]
          }
        }
      end

      it 'creates a new domain' do
        expect {
          post registrar_domains_path, params: valid_params
        }.to change(Domain, :count).by(1)
      end

      it 'redirects to the root path' do
        post registrar_domains_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          domain: {
            name: '',
            registrant_id: registrant.id,
            period: 1,
            reserved_pw: 'password',
            domain_contacts_attributes: [
              {
                contact_id: create(:contact).id,
                type: 'AdminDomainContact'
              },
              {
                contact_id: create(:contact).id,
                type: 'TechDomainContact'
              }
            ],
            nameservers_attributes: [
              {
                hostname: 'ns1.example.com',
                ipv4: '192.0.2.1',
                ipv6: '2001:db8::1'
              },
              {
                hostname: 'ns2.example.com',
                ipv4: '192.0.2.2',
                ipv6: '2001:db8::2'
              }
            ],
            dnssec_keys_attributes: [
              {
                flags: '256',
                protocol: '3',
                algorithm: '13',
                public_key: 'public_key'
              }
            ]
          }
        }
      end

      it 'does not create a new domain' do
        expect {
          post registrar_domains_path, params: invalid_params
        }.not_to change(Domain, :count)
      end
    end
  end
end
