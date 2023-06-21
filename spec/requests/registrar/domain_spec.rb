require 'rails_helper'

RSpec.describe Registrar::DomainsController, type: :request do
  let(:registrar_user) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }

  let(:tld) { create(:tld) }
  let(:registrant) { create(:contact) }
  let(:domain) { create(:domain, registrant: registrant)}

  let(:valid_params) do
    {
      domain: {
        name: 'example2.com',
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
                path: registrar_domains_path,
              },
              {
                method: :get,
                path: registrar_domain_path(uuid: domain.uuid),
              },
              {
                method: :get,
                path: edit_registrar_domain_path(uuid: domain.uuid),
              },
              {
                method: :get,
                path: new_registrar_domain_path,
              },
              {
                method: :post,
                path: registrar_domains_path,
                payload: valid_params
              },
              {
                method: :patch,
                path: registrar_domain_path(uuid: domain.uuid),
                payload: {
                  domain: {
                    reserved_pw: 'password1234',
                  }
                }
              },
              {
                method: :delete,
                path: registrar_domain_path(uuid: domain.uuid),
              },
             ]
            }
         }

  describe 'POST #create' do
    context 'with invalid parameters' do
      it 'does not create a new domain' do
        expect do
          post registrar_domains_path, params: invalid_params
        end.not_to change(Domain, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:domain) { create(:domain) }
    before(:each) do
      domain.reload
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          domain: {
            name: ''
            # add other attributes you want to update
          }
        }
      end

      it 'does not update the domain' do
        patch registrar_domain_path(uuid: domain.uuid), params: invalid_params
        domain.reload
        expect(domain.name).not_to eq('')
      end
    end
  end
end
