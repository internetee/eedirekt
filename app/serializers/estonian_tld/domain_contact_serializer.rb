module EstonianTld
  class DomainContactSerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      body = dirty['contacts']
      body.map do |contact|
        contact_struct = Struct.new(:code, :type, :name)

        contact_struct.new(contact['code'], contact['type'], contact['name'])
      end
    end
  end
end
