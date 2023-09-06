class Invoice < ApplicationRecord
  include Invoice::Buyer
  include Invoice::Number
  include Invoice::Searchable

  belongs_to :buyer, class_name: 'Contact', foreign_key: :buyer_id

  has_many :invoice_items, dependent: :destroy
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  enum status: {
    issued: 'issued', paid: 'paid', canceled: 'canceled', failed: 'failed', overdue: 'overdue'
  }

  scope :overdue, -> { unpaid.non_cancelled.where('due_date < ?', Time.zone.today) }

  validates :status, :due_date, :invoice_items, presence: true
  validates :number, uniqueness: { message: :uniqueness }

  after_initialize do
    self.vat_rate = Setting.vat || 20.0 if vat_rate.nil?
  end

  after_initialize do
    self.due_date = Time.zone.today + Setting.days_to_keep_invoices_active.days if due_date.nil?
  end

  def subtotal
    invoice_items.map(&:item_sum_without_vat).reduce(:+) || 0
  end

  def vat_amount
    if vat_rate.positive?
      subtotal * vat_rate / 100
    else
      subtotal
    end
  end

  def total
    # calculate_total unless total?
    # read_attribute(:total)

    calculate_total
  end

  private

  def calculate_total
    self.total = (subtotal + vat_amount).round(3)
  end
end
