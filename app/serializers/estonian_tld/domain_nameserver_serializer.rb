module EstonianTld
  class DomainNameserverSerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      body = dirty['nameservers']
      body.map do |nameserver|
        nameserver_struct = Struct.new(:hostname, :ipv4, :ipv6)

        nameserver_struct.new(nameserver['hostname'], nameserver['ipv4'], nameserver['ipv6'])
      end
    end
  end
end
