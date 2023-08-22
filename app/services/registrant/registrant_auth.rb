module Registrant
  class RegistrantAuth
    attr_reader :tara_params

    def initialize(tara_params:)
      @tara_params = tara_params
    end

    def self.call(tara_params:)
      new(tara_params:).call
    end

    def call
      @user = User.from_omniauth(tara_params)
      @user.save if @user.has_changes_to_save?

      registrant_create_app_session
    end

    private

    def registrant_create_app_session
      @user.app_sessions.create
    end

    def registrar_create_app_session
      @registrar.app_sessions.create
    end
  end
end
