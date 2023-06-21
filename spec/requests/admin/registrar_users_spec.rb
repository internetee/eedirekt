require 'rails_helper'

RSpec.describe 'Admin::RegistrarUsersController', type: :request do
  let(:registrar_user) { create(:registrar_user) }
  let(:registrar_user2) { create(:registrar_user) }
  let(:super_user) { create(:super_user) }

  it_behaves_like 'admin_permissions',
                  value: lambda {
                           { admin: super_user, registrar: registrar_user,
                             options: [
                              {
                                method: :delete,
                                path: admin_registrar_user_path(uuid: registrar_user2.uuid),
                              },
                              {
                                method: :get,
                                path: admin_registrar_users_path,
                              },
                              {
                                method: :get,
                                path: admin_registrar_user_path(uuid: registrar_user.uuid),
                              },
                              {
                                method: :get,
                                path: edit_admin_registrar_user_path(uuid: registrar_user.uuid),
                              },
                              {
                                method: :get,
                                path: new_admin_registrar_user_path,
                              },
                              {
                                method: :post,
                                path: admin_registrar_users_path,
                                payload: {
                                 registrar_user: {
                                   username: Faker::Name.name.gsub(' ', '_').underscore,
                                   password: '12345678',
                                   password_confirmation: '12345678'
                                 }
                               }
                              },
                              {
                                method: :patch,
                                path: admin_registrar_user_path(uuid: registrar_user.uuid),
                                payload: {
                                  registrar_user: {
                                    username: Faker::Name.name.gsub(' ', '_').underscore,
                                  }
                                }
                              },
                             ]
                            }
                         }
end
