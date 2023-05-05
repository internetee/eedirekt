module Contact::EstTld::Country
  extend ActiveSupport::Concern

  included do
    validate :validate_country_code
    validate :validate_address_country_code
  end

  private

  def validate_country_code
    if country_code.present? && !ISO3166::Country[country_code]
      errors.add(:country_code, 'должен быть действительным кодом страны в формате alpha2')
    end
  end

  def validate_address_country_code
    if address_country_code.present? && !ISO3166::Country[address_country_code]
      errors.add(:address_country_code, 'должен быть действительным кодом страны в формате alpha2')
    end
  end
end
