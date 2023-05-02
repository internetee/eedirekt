module EstonianTld
  class ContactSerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      body = dirty.body['data']['contacts']
      contact_struct = Struct.new(:name, :email, :phone, :ident, :code, :authInfo, :role,
                                  :country_code, :information, :remote_updated_at)

      body.map do |data|
        information = {
          address: data['address'],
          statuses: data['statuses'],
          registrar: data['registrar']
        }

        contact_struct.new(
          data['name'], data['email'], data['phone'], data['ident']['code'], data['code'], data['auth_info'],
          data['ident']['type'], data['ident']['country_code'], information, data['updated_at']
        )
      end
    end
  end
end
