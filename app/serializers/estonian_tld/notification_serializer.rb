module EstonianTld
  class NotificationSerializer
    attr_accessor :dirty

    def initialize(dirty)
      @dirty = dirty
    end

    def self.call(dirty:)
      new(dirty).call
    end

    def call
      body = dirty.body['data']
      notification_struct = Struct.new(:id, :text, :attached_obj_type, :attached_obj_id)

      body.map do |data|
        notification_struct.new(
          data['id'], data['text'], data['attached_obj_type'], data['attached_obj_id']
        )
      end
    end
  end
end
