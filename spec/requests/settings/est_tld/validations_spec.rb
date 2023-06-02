require 'rails_helper'

RSpec.describe 'Setttings::EstTld::Validations', type: :request do
  before do
    SuperUser.destroy_all
    ActionController::Base.allow_forgery_protection = false
  end

  after do
    ActionController::Base.allow_forgery_protection = true
  end

  it 'if user added files with invalid extensions should be return a Validation Error' do
    allow_any_instance_of(Settings::EstTld::ValidationsController).to receive(:validate_existance_in_server).and_return(false)

    post settings_est_tld_validations_path, params: {
      username: 'John',
      password: 'Doe',
    }

    expect(JSON.parse(response.body)['valid']).to eq false
  end

  it 'if user input invalid api user credenetials should be return an EPP Authroization Error' do
    xml_schema = <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="lib/schemas/epp-ee-1.0.xsd">
      <response>
        <result code="2501">
          <msg lang="en">Authentication error; server closing connection (API user not found)</msg>
        </result>
        <trID>
          <clTRID>John-1681464299</clTRID>
          <svTRID>ccReg-3613381698</svTRID>
        </trID>
      </response>
    </epp>
    XML

    allow_any_instance_of(Epp::Server).to receive(:send_request).and_return(xml_schema)

    post settings_est_tld_validations_path, params: {
      username: 'John',
      password: 'Doe'
    }

    expect(JSON.parse(response.body)['error']).to eq 'EPP Authorization message: Authentication error; server closing connection (API user not found)'
  end

  # TODO:
  # This feature is temporary disabled because no any decision about certificates

  # it 'if user added certificates what dismatch should be return a SSL Error' do
  #   post settings_est_tld_validations_path, params: {
  #     username: 'John',
  #     password: 'Doe',
  #   }

  #   expect(JSON.parse(response.body)['error']).to include 'SSL certificate error: SSL_connect returned'
  # end

  it 'connection should be established' do
    xml_schema = <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="lib/schemas/epp-ee-1.0.xsd">
      <response>
        <result code="1000">
          <msg>Command completed successfully</msg>
        </result>
        <trID>
          <clTRID>oleghasjanov-1681464382</clTRID>
          <svTRID>ccReg-3682032808</svTRID>
        </trID>
      </response>
    </epp>
    XML

    allow_any_instance_of(Epp::Server).to receive(:send_request).and_return(xml_schema)

    post settings_est_tld_validations_path, params: {
      username: 'oleghasjanov',
      password: '123456',
    }

    expect(JSON.parse(response.body)['valid']).to eq true
  end
end
