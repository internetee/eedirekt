class Settings::EstTld::ValidationsController < Settings::BaseController
  include Tlds::EstTldValidation

  allow_unauthenticated
  skip_before_action :redirect_to_welcome_page

  def create
    # @crt = params[:crt]
    # @key = params[:key]
    @username = params[:username]
    @password = params[:password]

    # crt_valid = @crt.present? && @crt.content_type.in?(["application/x-x509-ca-cert"])
    # key_valid = @key.present? && @key.content_type.in?(["application/x-x509-ca-cert"])
    # valid_extension = crt_valid && key_valid

    # Rails.logger.info '-------------- Settings::EstTld::ValidationsController'
    # Rails.logger.info crt_valid
    # Rails.logger.info key_valid
    # Rails.logger.info '--------------'

    if valid_extension
      validate_existance_in_server

      render json: { valid: true }
    else
      render json: { valid: valid_extension }
    end
  end
end
