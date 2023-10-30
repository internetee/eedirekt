require 'rails_helper'

RSpec.describe Registrar::InvoicesController, type: :request do
  let(:registrar_user) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }
  let(:setting) { create(:setting, code: 'days_to_keep_invoices_active', value: '30') }

  let(:tld) { create(:tld) }
  let(:invoice) { create(:invoice) }

  let(:contact) { create(:contact, ident: '60001019939') }

  let(:valid_params) do
    {
      invoice: {
        buyer_id: contact.id,
        name: contact.name,
        country_code: 'EE',
        state: 'Harjumaa',
        street: 'Toompea',
        city: 'Tallinn',
        zip: '12345',
        phone: '+372.123456789',
        url: 'www.example.com',
        email: contact.email,
        description: 'example description',
        invoice_items_attributes: [
          {
            unit_price: 10.0,
            quantity: 1,
            description: 'example description',
          }
        ]
      }
    }
  end

  let(:invalid_params) do
    {
      invoice: {
        buyer_id: contact.id,
        name: contact.name,
        country_code: 'EE',
        state: 'Harjumaa',
        street: 'Toompea',
        city: 'Tallinn',
        zip: '12345',
        phone: '+372.123456789',
        url: 'www.example.com',
        email: contact.email,
        description: 'example description',
      }
    }
  end

  before(:each) do
    setting.reload
  end

  it_behaves_like 'registrar_permissions',
  value: lambda {
           { admin: super_user, registrar: registrar_user,
             options: [
              {
                method: :get,
                path: registrar_invoices_path,
              },
              {
                method: :get,
                path: registrar_invoice_path(uuid: invoice.uuid),
              },
              {
                method: :get,
                path: edit_registrar_invoice_path(uuid: invoice.uuid),
              },
              {
                method: :get,
                path: new_registrar_invoice_path,
              },
              {
                method: :post,
                path: registrar_invoices_path,
                payload: valid_params
              },
              {
                method: :patch,
                path: registrar_invoice_path(uuid: invoice.uuid),
                payload: {
                  invoice: {
                    status: 'paid',
                  }
                }
              },
              {
                method: :delete,
                path: registrar_invoice_path(uuid: invoice.uuid),
              },
             ]
            }
         }
end