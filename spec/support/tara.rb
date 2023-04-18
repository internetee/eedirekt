module Tara
  extend RSpec::Mocks::ExampleMethods

  def login_by_tara(identity_code)
    get registrant_tara_callback_path + "?code=#{identity_code}"
  end
end

RSpec.shared_context 'tara_stubs', shared_context: :metadata do
  before do
    allow_any_instance_of(Registrant::Tara::TaraController).to receive(:access_token).and_return({ 'access_token' => 'Access Token' })
    allow_any_instance_of(Registrant::Tara::TaraController).to receive(:userinfo).and_return({
      'family_name' => 'TESTNUMBER',
      'given_name' => 'OK',
      'id_code' => 'EE30303039914',
      'auth_time' => '2023-04-05T12:55:56.000+03:00',
      'auth_method' => 'smartid'
    })
  end
end