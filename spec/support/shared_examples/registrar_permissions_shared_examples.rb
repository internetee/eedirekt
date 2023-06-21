require 'rails_helper'

RSpec.shared_examples 'registrar_permissions' do |value:|
  let(:expected_value) { instance_exec(&value) }

  let(:admin) { expected_value[:admin] }
  let(:registrar) { expected_value[:registrar] }
  let(:options) { expected_value[:options] }

  before(:each) do
    admin.reload && registrar.reload
  end

  it 'only registrar can access to registrar user actions' do
    options.each do |option|
      admin_login admin
      admin.reload
      
      send("#{option[:method]}", option[:path], params: option[:payload])
      
      expect(response.status).to eq 403
      
      logout
      
      registrar_login_basic_auth registrar
      registrar.reload
      
      send("#{option[:method]}", option[:path], params: option[:payload])

      if (option[:method] == :get)
        expect(response.status).to eq 200
      else
        expect(response.status).to eq 303
      end

      logout
    end
  end
end
