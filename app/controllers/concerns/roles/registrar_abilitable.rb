module Roles::RegistrarAbilitable
  extend ActiveSupport::Concern

  included do
    before_action :check_for_permissions_registrar_scope
  end

  class_methods do
    def skip_check_for_permissions_registrar_scope(**options)
      skip_before_action :check_for_permissions_registrar_scope, options
    end
  end

  def check_for_permissions_registrar_scope
    return if current_user.present? && current_user.class.name == 'RegistrarUser'

    render 'errors/403', status: :forbidden, layout: 'error'
  end
end
