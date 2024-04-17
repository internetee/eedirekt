module Admin
  class SettingsController < ApplicationController
    include Roles::AdminAbilitable

    def show
      @invoice_group = Setting.with_group('invoice')
      @contact_group = Setting.with_group('contacts')
      @registrar_group = Setting.with_group('registrar')
    end

    def update
      updated, errors = Admin::SettingUpdaterService.new(params).update
    
      if updated
        redirect_to root_path, status: :see_other, notice: t('.success')
      else
        flash[:alert] = errors.uniq.join(', ')
        render :show, status: :unprocessable_entity
      end
    end
  end
end
