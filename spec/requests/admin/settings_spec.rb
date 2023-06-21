require 'rails_helper'

RSpec.describe 'Settings', type: :request do
  let(:registrar_user) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }
  let(:setting) { create(:setting) }
  let(:payload_hash) do
    t = [setting].map { |settings| [settings.id.to_s, settings.value] }.to_h
    { "settings" => t }
  end

  it_behaves_like 'admin_permissions',
                  value: lambda {
                           { admin: super_user, registrar: registrar_user,
                             options: [
                              {
                                method: :get,
                                path: admin_settings_path,
                              },
                              {
                                method: :patch,
                                path: admin_settings_path,
                                payload: payload_hash
                              }
                             ]

  }}
end
