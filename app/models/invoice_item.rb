class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  delegate :vat_rate, to: :invoice
  delegate :buyer, to: :invoice

  def item_sum_without_vat
    (unit_price * quantity).round(3)
  end
  alias_method :subtotal, :item_sum_without_vat

  def vat_amount
    if vat_rate.positive?
      subtotal * (vat_rate / 100)
    else
      subtotal
    end
  end

  def total_sum
    (subtotal + vat_amount)
  end
end
