module Admin
  class SessionsController < ApplicationController
    allow_unauthenticated only: %i[new create]

    def new; end

    def create
      super_user = SuperUser.find_by(username: params[:username])
      if super_user&.authenticate(params[:password])
        app_token = super_user.app_sessions.create
        log_in app_token
        redirect_to root_path, status: :see_other, notice: { success: t('.success') }
      else
        render 'admin/sessions/new', status: :unprocessable_entity
      end
    end
  end
end
