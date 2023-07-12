module Settings
  class BaseController < ApplicationController
    before_action :redirect_to_admin_session

    layout 'sessions'

    private

    def redirect_to_admin_session
      redirect_to new_admin_sessions_path, status: :see_other, layout: 'sessions' if SuperUser.count > 0
    end
  end
end
