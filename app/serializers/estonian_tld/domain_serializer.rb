module EstonianTld
  class DomainSerializer
    attr_accessor :dirty

    ACTIVE_STATE = 1

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      domain_struct = Struct.new(:name, :remote_updated_at, :remote_created_at, :expire_at, :statuses, :information, :state)

      information = {
        outzone_at: dirty['outzone_at'],
        delete_date: dirty['delete_date'],
        force_delete_date: dirty['force_delete_date'],
        transfer_code: dirty['transfer_code'],
        dispute: dirty['dispute'],
        status_notes: dirty['status_notes'],
        metadata: {
          registry_created_at: dirty['created_at'],
          registry_updated_at: dirty['updated_at']
        }
      }

      domain_struct.new(
        dirty['name'], dirty['updated_at'], dirty['created_at'],
        dirty['expire_time'], dirty['statuses'].keys.map(&:to_s), information, ACTIVE_STATE
      )
    end
  end
end
