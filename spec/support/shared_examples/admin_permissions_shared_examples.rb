RSpec.shared_examples 'admin_permissions' do |controller_name, value:|
  let(:expected_value) { instance_exec(&value) }

  let(:admin) { expected_value[:admin] }
  let(:registrar) { expected_value[:registrar] }
  let(:payload) { expected_value[:payload] }

  before(:each) do
    admin.reload && registrar.reload
  end

  it 'only admin can access to index action' do
    registrar_login_basic_auth registrar

    get send("#{controller_name}s_path")
    expect(response.status).to eq 403

    logout

    admin_login admin

    get send("#{controller_name}s_path")
    expect(response.status).to eq 200
  end

  it 'only admin can access to show action' do
    registrar_login_basic_auth registrar

    get send("#{controller_name}_path", uuid: registrar.uuid)
    expect(response.status).to eq 403

    logout

    admin_login super_user

    get send("#{controller_name}_path", uuid: registrar.uuid)
    expect(response.status).to eq 200
  end

  it 'only admin can access to new action' do
    registrar_login_basic_auth registrar_user

    get send("new_#{controller_name}_path")
    expect(response.status).to eq 403

    logout

    admin_login super_user

    get send("new_#{controller_name}_path")
    expect(response.status).to eq 200
  end

   it 'only admin can access to edit action' do
    registrar_login_basic_auth registrar_user

    get send("edit_#{controller_name}_path", uuid: registrar.uuid)
    expect(response.status).to eq 403

    logout

    admin_login super_user

    get send("edit_#{controller_name}_path", uuid: registrar.uuid)
    expect(response.status).to eq 200
  end

  it 'only admin can access to destroy action' do
    registrar_login_basic_auth registrar_user

    delete send("#{controller_name}_path", uuid: registrar.uuid)
    expect(response.status).to eq 403

    logout

    admin_login super_user

    delete send("#{controller_name}_path", uuid: registrar.uuid)
    expect(response.status).to eq 303
  end

  it 'only admin can access to create action' do
    registrar_login_basic_auth registrar_user

    post send("#{controller_name}s_path", uuid: registrar.uuid), params: payload
    expect(response.status).to eq 403

    logout

    admin_login super_user

    post send("#{controller_name}s_path", uuid: registrar.uuid), params: payload
    expect(response.status).to eq 303
  end

  it 'only admin can access to update action' do
    registrar_login_basic_auth registrar_user

    patch send("#{controller_name}_path", uuid: registrar.uuid), params: payload
    expect(response.status).to eq 403

    logout

    admin_login super_user

    patch send("#{controller_name}_path", uuid: registrar.uuid), params: payload
    expect(response.status).to eq 303
  end

end
