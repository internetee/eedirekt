require 'rails_helper'

RSpec.describe "Admin::Synchronizes", type: :request do
  let(:admin) { create(:super_user) }
  let(:tld) { create(:tld) }

  let(:registrar_user) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }

  before(:each) do
    tld.reload
    admin_login admin
  end

  describe "POST /create" do
    subject { post admin_synchronizes_path }

    # Comment out until redis on staging will fixed

    # it 'queues the EstonianTld::ContactsJob' do
    #   VCR.use_cassette('synchronize_contacts_job_1') do
    #     expect {
    #       subject
    #     }.to have_enqueued_job(EstonianTld::ContactsJob).with(tld)
    #   end
    # end

    it 'redirects to the root path' do
      VCR.use_cassette('synchronize_contacts_job_2') do
        subject
        expect(response).to redirect_to(root_path)
      end
    end

    it 'sets a success flash message' do
      VCR.use_cassette('synchronize_contacts_job_3') do
        subject
        expect(flash[:notice][:success]).to eq I18n.t('admin.synchronizes.create.success')
      end
    end
  end
end
