require 'rails_helper'

RSpec.describe 'Setttings::EstTld::Validations', type: :request do
  before do
    SuperUser.destroy_all
    ActionController::Base.allow_forgery_protection = false
  end

  after do
    ActionController::Base.allow_forgery_protection = true
  end

  it 'could not create a super user if credentials are invalid' do
    xml_schema = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="lib/schemas/epp-ee-1.0.xsd">
        <response>
          <result code="2501">
            <msg lang="en">Authentication error; server closing connection (API user not found)</msg>
          </result>
          <trID>
            <clTRID>john-1681463538</clTRID>
            <svTRID>ccReg-9039380545</svTRID>
          </trID>
        </response>
      </epp>
    XML

    allow_any_instance_of(Epp::Server).to receive(:open_connection).and_return(xml_schema)
    allow_any_instance_of(Epp::Server).to receive(:send_request).and_return(xml_schema)

    crt_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.crt.pem"
    key_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.key.pem"
    expect(SuperUser.count).to eq 0

    expect do
      post settings_configurations_path, params: {
        super_user: {
          username: 'superuser',
          email: 'superuser@example.com',
          password: 'password',
          password_confirmation: 'password'
        },
        tld: {
          username: 'john',
          password: 'doe',
          crt: fixture_file_upload(crt_file_path, 'application/x-x509-ca-cert'),
          key: fixture_file_upload(key_file_path, 'application/x-x509-ca-cert')
        }
      }
    end.to change { SuperUser.count }.by 0
  end

  # TODO:
  # This feature is temporaruy disabled because no any decision about certificates

  # it 'could not create a super user if certificates are invalid' do
  #   csr_file_path = "#{Rails.root}/spec/support/fixtures/certificates/csr_fake.pem"
  #   mock_pdf_file_path = "#{Rails.root}/spec/support/fixtures/mock.pdf"
  #   expect(SuperUser.count).to eq 0

  #   expect do
  #     post settings_configurations_path, params: {
  #       super_user: {
  #         username: 'superuser',
  #         email: 'superuser@example.com',
  #         password: 'password',
  #         password_confirmation: 'password'
  #       },
  #       tld: {
  #         username: 'oleghasjanov',
  #         password: '123456',
  #         crt: fixture_file_upload(csr_file_path, 'application/x-x509-ca-cert'),
  #         key: fixture_file_upload(mock_pdf_file_path, 'application/pdf')
  #       }
  #     }
  #   end.to change { SuperUser.count }.by 0

  #   expect(response.status).to eq 422
  # end

  it 'should create a valid superuser with valid tld credentials' do
    xml_schema = <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="lib/schemas/epp-ee-1.0.xsd">
      <response>
        <result code="1000">
          <msg>Command completed successfully</msg>
        </result>
        <trID>
          <clTRID>oleghasjanov-1681463802</clTRID>
          <svTRID>ccReg-0164862546</svTRID>
        </trID>
      </response>
    </epp>
    XML

    allow_any_instance_of(Epp::Server).to receive(:open_connection).and_return(xml_schema)
    allow_any_instance_of(Epp::Server).to receive(:send_request).and_return(xml_schema)

    crt_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.crt.pem"
    key_file_path = "#{Rails.root}/spec/support/fixtures/certificates/webclient.key.pem"
    expect(SuperUser.count).to eq 0

    expect do
      post settings_configurations_path, params: {
        super_user: {
          username: 'superuser',
          email: 'superuser@example.com',
          password: 'password',
          password_confirmation: 'password'
        },
        tld: {
          username: 'oleghasjanov',
          password: '123456',
          crt: fixture_file_upload(crt_file_path, 'application/x-x509-ca-cert'),
          key: fixture_file_upload(key_file_path, 'application/x-x509-ca-cert')
        }
      }
    end.to change { SuperUser.count }.by 1
  end
end
