module Settings
  class ConfigurationsController < BaseController
    include Tlds::EstTldValidation

    allow_unauthenticated
    skip_before_action :redirect_to_welcome_page

    def index; end

    def create
      @crt = tld_params[:crt]
      @key = tld_params[:key]
      @username = tld_params[:username]
      @password = tld_params[:password]

      crt_valid = @crt.present? && @crt.content_type.in?(["application/x-x509-ca-cert"])
      key_valid = @key.present? && @key.content_type.in?(["application/x-x509-ca-cert"])
      valid_extension = crt_valid && key_valid

      render 'settings/configurations/index', status: :unprocessable_entity and return unless valid_extension

      validate_existance_in_server

      @super_user = SuperUser.new(user_params)
      @tld = Tld.new(tld_params)

      if @super_user.valid? && @tld.valid?
        @super_user.save! && @tld.save!
        @app_session = create_app_session

        log_in @app_session
        redirect_to root_path, notice: t('.signed_in'), status: :see_other
      else
        Rails.logger.warn @super_user.errors.full_messages
        Rails.logger.warn @tld.errors.full_messages

        flash.now[:danger] = I18n.t('.incorrect_details')
        render 'settings/configurations/index', status: :unprocessable_entity
      end
    end

    private

    def create_session_and_authorize
      app_session = @user.app_sessions.create
      log_in app_session
    end

    def create_app_session
      @super_user.app_sessions.create
    end

    def user_params
      params.require(:super_user).permit(SuperUser.permitted_attributes)
    end

    def tld_params
      params.require(:tld).permit(Tld.permitted_attributes)
    end
  end
end
