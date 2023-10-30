module Admin
  class SettingsController < ApplicationController
    include Roles::AdminAbilitable

    def show
      @invoice_group = Setting.with_group('invoice')
      @contact_group = Setting.with_group('contacts')
    end

    def update
      if Setting.update(casted_settings.keys, casted_settings.values)
        redirect_to root_path, status: :see_other, notice: t('.success')
      else
        flash[:alert] = update.errors.values.uniq.join(', ')
        render :show, status: :unprocessable_entity
      end
    end

    private

    def casted_settings
      settings = {}

      params[:settings].each do |k, v|
        settings[k] = { value: v }
      end

      settings
    end
  end
end
