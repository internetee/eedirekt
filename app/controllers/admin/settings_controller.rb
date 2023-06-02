module Admin
  class SettingsController < ApplicationController
    def show
      @invoice_group = Setting.with_group('invoice')
    end

    def update
      puts '------'
      puts params
      puts casted_settings.keys
      puts casted_settings.values
      puts '------'

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
