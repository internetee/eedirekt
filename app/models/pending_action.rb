class PendingAction < ApplicationRecord
  belongs_to :user
  belongs_to :invoice, optional: true

  enum status: { pending: 100, completed: 200, declined: 300, failed: 400 }
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
