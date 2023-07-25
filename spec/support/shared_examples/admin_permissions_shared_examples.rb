require 'rails_helper'

RSpec.shared_examples 'admin_permissions' do |value:|
  let(:expected_value) { instance_exec(&value) }

  let(:admin) { expected_value[:admin] }
  let(:registrar) { expected_value[:registrar] }
  let(:options) { expected_value[:options] }

  before(:each) do
    # admin.reload && registrar.reload
  end

  it 'only admin can access to super user actions' do
    options.each do |option|
      registrar_login_basic_auth registrar

      registrar.reload
      send("#{option[:method]}", option[:path], params: option[:payload])

      expect(response.status).to eq 403

      logout

      admin_login admin

      send("#{option[:method]}", option[:path], params: option[:payload])
      admin.reload

      if (option[:method] == :get)
        expect(response.status).to eq 200
      else
        expect(response.status).to eq 303
      end

      logout
    end
  end
end
