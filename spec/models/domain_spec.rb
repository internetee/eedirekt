require 'rails_helper'

RSpec.describe Domain, type: :model do
  describe 'associations' do
    it { should have_many(:domain_contacts).dependent(:destroy) }
    it { should have_many(:contacts).through(:domain_contacts) }
    it { should have_many(:admin_domain_contacts) }
    it { should have_many(:tech_domain_contacts) }
    it { should have_many(:admin_contacts).through(:admin_domain_contacts).source(:contact) }
    it { should have_many(:tech_contacts).through(:tech_domain_contacts).source(:contact) }
    it { should have_many(:nameservers).dependent(:destroy).inverse_of(:domain) }
    it { should have_many(:dnssec_keys).dependent(:destroy) }
    it { should belong_to(:registrant) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:admin_domain_contacts) }
    it { should accept_nested_attributes_for(:tech_domain_contacts) }
    it { should accept_nested_attributes_for(:nameservers) }
  end
end
