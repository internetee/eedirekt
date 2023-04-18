module Registrar
  module Tara
    class TaraController < ApplicationController
      skip_authentication

      include TaraAccessable

      rescue_from ActiveRecord::RecordNotFound, with: :no_user

      def callback
        response = access_token(params[:code])
        user_info = userinfo(response['access_token'])

        @registrar = RegistrarUser.from_omniauth(user_info)
        raise ActiveRecord::RecordNotFound if @registrar.nil?

        @registrar.save if @registrar.has_changes_to_save?

        @app_session = create_app_session
        if @app_session
          log_in @app_session

          redirect_to root_path, notice: t('.signed_in'), status: :see_other
        else
          flash.now[:danger] = I18n.t('.incorrect_details')
          render 'sessions/new', status: :unprocessable_entity
        end
      end

      def cancel
        redirect_to root_path, notice: t('.cancelled')
      end

      def identifier
        ENV['registrar_tara_identifier']
      end

      def secret
        ENV['registrar_tara_secret']
      end

      private

      def no_user
        render 'sessions/new', status: :unprocessable_entity
      end

      def create_app_session
        @registrar.app_sessions.create
      end
    end
  end
end
