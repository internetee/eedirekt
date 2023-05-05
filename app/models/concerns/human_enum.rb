module HumanEnum
  extend ActiveSupport::Concern

  class_methods do
    def human_enum_name(enum_name, enum_value)
      model_key = model_name.i18n_key
      enum_key = enum_name.to_s.pluralize
      I18n.t(
        'activerecord.attributes.'\
        "#{model_key}.#{enum_key}.#{enum_value}",
        default: enum_value.to_s.humanize
      )
    end

    def human_enum_options(enum_name)
      send(enum_name.to_s.pluralize).map do |key, _value|
        [human_enum_name(enum_name, key), key]
      end.to_h
    end
  end

  def human_enum_value(enum_name)
    enum_value = send(enum_name)
    self.class.human_enum_name(enum_name, enum_value)
  end
end
