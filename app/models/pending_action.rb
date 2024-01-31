class PendingAction < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :invoice, optional: true

  enum status: { pending: 100, completed: 200, declined: 300, failed: 400 }

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :completed
    state :declined
    state :failed

    event :complete do
      transitions from: :pending, to: :completed
    end

    event :decline do
      transitions from: :pending, to: :declined
    end

    event :fail do
      transitions from: :pending, to: :failed
    end
  end

  validate :unable_to_update

  def unable_to_update
    return if pending?
    return if invoice.issued?

    errors.add(:base, I18n.t('errors.messages.unable_to_update'))
  end

  def can_i_edit_it?
    pending? && invoice.issued?
  end

  enum action: { 
    domain_create: 100, 
    domain_update: 200,
    domain_delete: 300,
    contact_create: 400,
    contact_update: 500,
    contact_delete: 600, 
  }

  validates :user, :info, :action, :status, presence: true

  def create_invoice_by_pending_action
    # TODO: Implement sum depends of action and price list of registrar

    Invoice.create_invoice_for_registrant(registrant_user: user, sum: 100, pending_action: self)
  end
end
