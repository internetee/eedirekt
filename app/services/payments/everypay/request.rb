module Payments
  module Everypay
    module Request
      include Payments::Everypay::Connection

      TIMEOUT_IN_SECONDS = 5

      def get(path:, params: {})
        respond_with(
          connection(options: options).get(path, params)
        )
      end
    
      def post(path:, params: {})

        respond_with(
          connection(options: options).post(path, JSON.dump(params))
        )
      end
    
      def put_request(direction:, path:, params: {})
        respond_with(
          connection(options: options).put(path, JSON.dump(params))
        )
      end
    
      private
    
      def respond_with(response)
        JSON.parse response.body
      end
    
      def options
        {
          request: { timeout: timeout },
          headers: {
            'Authorization' => "Basic #{generate_basic_token}",
            'Content-Type' => 'application/json',
          },
        }
      end
    
      def generate_basic_token
        Base64.urlsafe_encode64("#{ENV['api_username']}:#{ENV['everypay_key']}")
      end
    
      def timeout
        @timeout ||= TIMEOUT_IN_SECONDS
      end
    end
  end
end
