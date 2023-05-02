class Domain < ApplicationRecord
  has_many :domain_contacts, dependent: :destroy
  has_many :contacts, through: :domain_contacts, source: :contact

  has_many :admin_domain_contacts
  has_many :tech_domain_contacts

  has_many :admin_contacts, through: :admin_domain_contacts, source: :contact
  has_many :tech_contacts, through: :tech_domain_contacts, source: :contact

  accepts_nested_attributes_for :admin_domain_contacts,
                                allow_destroy: true, reject_if: :admin_change_prohibited?
  accepts_nested_attributes_for :tech_domain_contacts,
                                allow_destroy: true, reject_if: :tech_change_prohibited?

  has_many :nameservers, dependent: :destroy, inverse_of: :domain
  accepts_nested_attributes_for :nameservers, allow_destroy: true,
                                              reject_if: proc { |attrs| attrs[:hostname].blank? }

  has_many :dnssec_keys, dependent: :destroy
  belongs_to :registrant, class_name: 'Contact', foreign_key: :registrant_id
end
