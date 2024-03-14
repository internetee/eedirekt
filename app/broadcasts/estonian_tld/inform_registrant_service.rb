module EstonianTld
  class InformRegistrantService < ApplicationService
    attr_reader :message, :tld

    def initialize(params)
      super

      @message = params[:message]
      @tld = params[:tld]
    end

    def call
      post_call
    end

    private

    def post_call
      broadcast_later "dashboards_#{tld.uuid}",
                      'dashboards/streams/registrant_replaced',
                      locals: { message: }
    end
  end
end
