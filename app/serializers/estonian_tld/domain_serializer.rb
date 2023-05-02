module EstonianTld
  class DomainSerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      domain_struct = Struct.new(:name, :remote_updated_at, :remote_created_at, :expire_at, :statuses, :information)

      information = {
        outzone_at: dirty['outzone_at'],
        delete_date: dirty['delete_date'],
        force_delete_date: dirty['force_delete_date'],
        transfer_code: dirty['transfer_code'],
        dispute: dirty['dispute']
      }

      domain_struct.new(
        dirty['name'], dirty['updated_at'], dirty['created_at'],
        dirty['expire_time'], dirty['statuses'].keys.map(&:to_s), information
      )
    end
  end
end
