require 'rails_helper'

RSpec.describe 'Registrar::Tara:Tara', type: :request do
  include_context 'tara_stubs'

  let(:registrar_user) { create(:registrar_user) }

  before(:each) do
    SuperUser.create!(
      username: 'username',
      password: 'password',
    )
  end

  it 'user can login through tara' do
    VCR.use_cassette('registrant_tara_login') do
      login_by_tara registrar_user.code
    end

    expect(response.status).to eq 303
  end
end
