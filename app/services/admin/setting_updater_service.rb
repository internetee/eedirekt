module Admin
  class SettingUpdaterService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def update
      updated = true
      errors = []
    
      casted_settings.each do |id, setting_params|
        setting = Setting.find_by(id: id)

        if setting.update!(setting_params)
          next
        else
          updated = false
          errors += setting.errors.full_messages
        end
      end

      return updated, errors
    end

    private

    def casted_settings
      settings_values = {}
    
      params.require(:settings).permit!
    
      params[:settings].each do |k, v|
        setting = Setting.find_by(id: k)

        next unless setting
    
        formatted_value = format_setting_value(v, setting.format)
        settings_values[setting.id] = { value: formatted_value }
      end
    
      settings_values
    end
    
    def format_setting_value(value, format_type)
      case format_type
      when 'boolean'
        (value.to_s == 'true').to_s
      when 'integer'
        value.to_i
      when 'float'
        value.to_f
      when 'hash'
        value.is_a?(ActionController::Parameters) ? value.to_unsafe_h.to_json : value
      when 'array'
        if value.is_a?(Array) && value.first.is_a?(ActionController::Parameters)
          value.map(&:to_unsafe_h).to_json
        else
          value.to_json
        end
      else
        value
      end
    end
  end
end