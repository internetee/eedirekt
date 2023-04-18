require 'rails_helper'

RSpec.describe 'RegistrarUsers', type: :request do
  let(:registrar_user) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }

  it_behaves_like 'admin_permissions', 'registrar_user',
                  value: lambda {
                           { admin: super_user, registrar: registrar_user,
                             payload: {
                               registrar_user: {
                                 username: Faker::Name.name.gsub(' ', '_').underscore,
                                 password: '12345678',
                                 password_confirmation: '12345678'
                               }
                             } }
                         }
end
