module Registrar
  class RegistrarAuth
    attr_reader :tara_params

    def initialize(tara_params:)
      @tara_params = tara_params
    end

    def self.call(tara_params:)
      new(tara_params:).call
    end

    def call
      @registrar = RegistrarUser.from_omniauth(tara_params)
      raise ActiveRecord::RecordNotFound if @registrar.nil?

      @registrar.save if @registrar.has_changes_to_save?
      registrar_create_app_session
    end

    private

    def registrar_create_app_session
      @registrar.app_sessions.create!
    end
  end
end
