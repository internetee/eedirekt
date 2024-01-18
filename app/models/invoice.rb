class Invoice < ApplicationRecord
  include Invoice::Buyer
  include Invoice::Number
  include Invoice::Searchable

  belongs_to :buyer, class_name: 'Contact', foreign_key: :buyer_id
  has_one :pending_action, dependent: :destroy

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

  def self.create_invoice_for_registrant(registrant_user:, sum:, pending_action: nil)
    contact = Contact.find_by(code: registrant_user.code)

    unless contact
      Rails.logger.info "No contact found"
      i = Invoice.new
      i.errors.add(:base, 'No contact found')

      return i
    end

    invoice_item = InvoiceItem.new(
      description: 'TODO: add description',
      quantity: 1,
      unit_price: sum,
    )

    invoice = new(
      buyer: contact,
      description: 'TODO: add description',
      reference_number: 'TODO: add reference_number',
      vat_rate: Setting.vat || 22.0,
      due_date: Time.zone.today + Setting.days_to_keep_invoices_active.days,
      issue_date: Time.zone.today,
      cancel_date: nil,
      invoice_items: [invoice_item],
      pending_action: pending_action,
    )

    invoice.calculate_total

    invoice.save

    Rails.logger.info "Invoice errors: #{invoice.errors.full_messages}"

    invoice
  end

  def calculate_total
    self.total = (subtotal + vat_amount).round(3)
  end
end
