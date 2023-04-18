require 'rails_helper'

RSpec.describe 'Setttings::Introduces', type: :request do
  it 'if super user not exist, user should pass wizard' do
    expect(SuperUser.count).to eq 0

    get root_path
    expect(response.status).to eq 303
    expect(response).to redirect_to settings_introduces_path

    get new_sessions_path
    expect(response.status).to eq 303
    expect(response).to redirect_to settings_introduces_path
  end

  it 'if super user exists, user can be in root_path' do
    SuperUser.create!(
      username: 'superuser',
      password: 'password'
    )

    get new_sessions_path
    expect(response.status).to eq 200
  end

  it 'if system is set up, user redirected to root_path' do
    SuperUser.create!(
      username: 'superuser',
      password: 'password'
    )

    get settings_introduces_path
    expect(response.status).to eq 303
    expect(response).to redirect_to new_admin_sessions_path
  end
end
