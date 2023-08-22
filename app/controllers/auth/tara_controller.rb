require 'countries'

module Auth
  class TaraController < ApplicationController
    skip_authentication

    before_action :clear_from_credentials, only: :callback

    include TaraAccessable

    rescue_from ActiveRecord::RecordNotFound, with: :no_user

    def callback
      if app_session
        log_in app_session

        redirect_to root_path, notice: t('.signed_in'), status: :see_other
      else
        flash.now[:danger] = I18n.t('.incorrect_details')
        render 'sessions/new', status: :unprocessable_entity
      end
    end

    def setup
      request.env['omniauth.strategy'].options.merge!(options)

      render plain: 'Omniauth setup phase', status: 404
    end

    def cancel
      redirect_to root_path, notice: t(:sign_in_cancelled)
    end

    private

    def no_user
      render 'sessions/new', status: :unprocessable_entity
    end

    def app_session
      @app_session ||= if tara_params_initiator == 'registrant'
                         Registrant::RegistrantAuth.call(tara_params: @user_info)
                       elsif tara_params_initiator == 'registrar'
                         Registrar::RegistrarAuth.call(tara_params: @user_info)
                       end
    end

    def clear_from_credentials
      @user_info = user_hash.delete_if { |key, _| key == 'credentials' }
    end

    def user_hash
      request.env['omniauth.auth']
    end
  end
end
