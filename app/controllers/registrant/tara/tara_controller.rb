module Registrant
  module Tara
    class TaraController < ApplicationController
      skip_authentication

      include TaraAccessable

      def callback
        response = access_token(params[:code])
        user_info = userinfo(response['access_token'])

        @user = User.from_omniauth(user_info)
        @user.save if @user.has_changes_to_save?

        @app_session = create_app_session
        if @app_session
          log_in @app_session

          redirect_to root_path, notice: t('devise.sessions.signed_in'), status: :see_other
        else
          flash.now[:danger] = I18n.t('.incorrect_details')
          render 'sessions/new', status: :unprocessable_entity
        end
      end

      def cancel
        redirect_to root_path, notice: t('.cancelled')
      end

      def identifier
        ENV['user_tara_identifier']
      end

      def secret
        ENV['user_tara_secret']
      end

      private

      def create_app_session
        @user.app_sessions.create
      end
    end
  end
end
