module Registrar
  class SessionsController < ApplicationController
    layout 'sessions'

    allow_unauthenticated only: %i[new create]

    def new
      redirect_to root_path if logged_in?
    end

    def create
      registrar_user = RegistrarUser.find_by(username: params[:username])

      if registrar_user&.authenticate(params[:password])
        app_token = registrar_user.app_sessions.create
        log_in app_token
        redirect_to root_path, status: :see_other, notice: { success: t('.success') }
      else
        render 'registrar/sessions/new', status: :unprocessable_entity
      end
    end

    def destroy
      logout

      flash[:success] = t('.success')
      redirect_to new_sessions_path, status: :see_other
    end
  end
end
