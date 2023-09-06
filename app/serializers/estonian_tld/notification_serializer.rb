module EstonianTld
  class NotificationSerializer
    attr_accessor :body

    def initialize(body)
      @body = body
    end

    def self.call(body:)
      new(body).call
    end

    def call
      notification_struct = Struct.new(:id, :text, :attached_obj_type, :attached_obj_id, :created_at) do
        def initialize(id, text, attached_obj_type, attached_obj_id, created_at = nil)
          super(id, text, attached_obj_type, attached_obj_id, created_at)
        end
      end

      body.map do |data|
        notification_struct.new(
          data['id'], data['text'], data['attached_obj_type'], data['attached_obj_id'], data['created_at']
        )
      end
    end
  end
end
