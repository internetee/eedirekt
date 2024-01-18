module Phone
  extend ActiveSupport::Concern

  def combine_phone_and_phone_code
    self.phone = "+#{phone_code}#{Phonelib.parse(phone).national(false)}"
  end

  def registrar_phone
    self.registrar_format_phone = "+#{phone_code}.#{Phonelib.parse(phone).national(false)}"
  end

  def split_phone_into_code_and_number
    parsed_phone = Phonelib.parse(phone)
    self.phone_code = parsed_phone.country_code
    self.phone = parsed_phone.national(false)
  end
end
