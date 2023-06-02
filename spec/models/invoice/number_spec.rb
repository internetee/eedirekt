require 'rails_helper'

RSpec.describe Invoice::Number, type: :model do
  before(:each) do
    Setting.create(code: 'invoice_number_min', value: '999', format: 'integer', group: 'invoice')
    Setting.create(code: 'invoice_number_max', value: '199999', format: 'integer', group: 'invoice')
    Setting.create(code: 'days_to_keep_invoices_active', value: '30', format: 'integer', group: 'billing')
    Setting.create(code: 'vat', value: '20.0', format: 'float', group: 'invoice')
  end

  context 'new invoice' do
    let(:invoice) { build(:invoice) }

    it 'should assign invoice number for first invoice' do
      min_value = Setting.invoice_number_min || 999
      expect { invoice.save && invoice.reload }.to change { invoice.number }.from(nil).to(min_value)
    end

  end

  context 'existing invoice' do
    let!(:invoice) { create(:invoice) }
    let!(:invoice2) { build(:invoice) }

    it 'should assing next invoice number after previous invoice' do
      invoice.reload
      invoice2.save! && invoice2.reload
      expect(invoice2.number).to eq(invoice.number + 1)
    end
  end

  context 'invoice limitation' do
    let!(:invoice) { build(:invoice) }

    before(:each) do
      Setting.invoice_number_max = 999
    end
    
    it 'should return error if invoice number exceeded' do
      begin
        invoice.save!
      rescue ActiveRecord::RecordInvalid => e
        expect(e.message).to eq "Validation failed: #{I18n.t('.invoice_number_exceeded')}"
      end
    end
  end
end
