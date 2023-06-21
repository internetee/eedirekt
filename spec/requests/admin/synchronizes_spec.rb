require 'rails_helper'

RSpec.describe "Admin::Synchronizes", type: :request do
  let(:admin) { create(:super_user) }
  let(:tld) { create(:tld) }

  let(:registrar_user) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }

  it_behaves_like 'admin_permissions',
                  value: lambda {
                           { admin: super_user, registrar: registrar_user,
                             options: [
                              {
                                method: :post,
                                path: admin_synchronizes_path,
                              }]
                           }}

  before(:each) do
    admin_login admin
  end

  describe "POST /create" do
    subject { post admin_synchronizes_path }

    it 'queues the EstonianTld::ContactsJob' do
      expect {
        subject
      }.to have_enqueued_job(EstonianTld::ContactsJob).with(tld)
    end

    it 'redirects to the root path' do
      subject
      expect(response).to redirect_to(root_path)
    end

    it 'sets a success flash message' do
      subject
      expect(flash[:notice][:success]).to eq I18n.t('admin.synchronizes.create.success')
    end
  end
end
