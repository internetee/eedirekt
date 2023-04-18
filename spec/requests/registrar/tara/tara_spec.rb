require 'rails_helper'

RSpec.describe 'Registrar::Tara:Tara', type: :request do
  before(:each) do
    SuperUser.create!(
      username: 'username',
      password: 'password',
    )
  end

  it 'registrar connot login through eeid if he is not in system' do
    allow_any_instance_of(Registrar::Tara::TaraController).to receive(:access_token).and_return({ 'access_token' => 'Access Token' })
    allow_any_instance_of(Registrar::Tara::TaraController).to receive(:userinfo).and_return({
      'family_name' => 'TESTNUMBER',
      'given_name' => 'OK',
      'id_code' => 'EE30303039914',
      'auth_time' => '2023-04-05T12:55:56.000+03:00',
      'auth_method' => 'smartid'
    })

    get registrar_tara_callback_path + '?code=some_code'

    expect(response.status).to eq 422
  end

  it 'registrar can login through eeid if he in system' do
    RegistrarUser.create!(
      code: '30303039914',
      name: 'TESTNUMBER OK'
    )

    allow_any_instance_of(Registrar::Tara::TaraController).to receive(:access_token).and_return({ 'access_token' => 'Access Token' })
    allow_any_instance_of(Registrar::Tara::TaraController).to receive(:userinfo).and_return({
      'family_name' => 'TESTNUMBER',
      'given_name' => 'OK',
      'id_code' => 'EE30303039914',
      'auth_time' => '2023-04-05T12:55:56.000+03:00',
      'auth_method' => 'smartid'
    })

    get registrar_tara_callback_path + '?code=some_code'

    expect(response.status).to eq 303
  end
end
