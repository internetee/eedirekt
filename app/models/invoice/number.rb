module Invoice::Number
  extend ActiveSupport::Concern

  included do
    before_save :number_generator
  end

  private

  def number_generator
    min_value = Setting.invoice_number_min || 999
    max_value = Setting.invoice_number_max || 199_999

    last_no = Invoice.all.where(number: min_value...max_value).order(number: :desc).limit(1).pick(:number)

    last_no = min_value - 1 if last_no.nil?
    number = last_no && last_no >= min_value ? last_no.to_i + 1 : min_value

    if number <= max_value
      self.number = number
    else
      throw :abort, t('.invoice_number_exceeded')
    end
  end
end
