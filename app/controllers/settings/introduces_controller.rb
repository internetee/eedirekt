module Settings
  class IntroducesController < BaseController
    allow_unauthenticated
    skip_before_action :redirect_to_welcome_page

    def index; end
  end
end
