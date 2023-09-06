module EstonianTld
  class BalanceSerializer
    attr_accessor :body

    def initialize(body)
      @body = body
    end

    def self.call(body:)
      new(body).call
    end

    def call
      contact_struct = Struct.new(:amount, :currency)

      contact_struct.new(body['amount'], body['currency'])
    end
  end
end
