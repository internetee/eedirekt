module EstonianTld
  class DomainRegistrantSerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      body = dirty['registrant']
      registrant_struct = Struct.new(:name, :code)

      registrant_struct.new(body['name'], body['code'])
    end
  end
end
