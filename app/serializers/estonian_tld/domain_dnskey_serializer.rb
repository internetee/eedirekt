module EstonianTld
  class DomainDnskeySerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      body = dirty['dnssec_keys']
      body.map do |dnssec_key|
        dnssec_key_struct = Struct.new(:flags, :protocol, :alg, :public_key)
        dnssec_key_struct.new(dnssec_key['flags'], dnssec_key['protocol'], dnssec_key['alg'], dnssec_key['public_key'])
      end
    end
  end
end
