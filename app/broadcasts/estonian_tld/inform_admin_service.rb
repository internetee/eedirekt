module EstonianTld
  class InformAdminService < ApplicationService
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
                      'admin/streams/replaced',
                      locals: { message: }
    end
  end
end
