class Domain < ApplicationRecord
  include Domain::Searchable
  include Domain::Statuses
  include Domain::Renewable

  PERIOD = [
    ['1 month', 1], ['3 month', 3], ['6 month', 6], ['1 year', 12], ['2 year', 24]
  ].freeze

  enum state: { draft: 0, active: 1 }

  has_many :domain_contacts, dependent: :destroy
  has_many :contacts, through: :domain_contacts, source: :contact

  has_many :admin_domain_contacts
  has_many :tech_domain_contacts

  has_many :admin_contacts, through: :admin_domain_contacts, source: :contact
  has_many :tech_contacts, through: :tech_domain_contacts, source: :contact

  store_accessor :information, :status_notes, :metadata
  attr_accessor :period

  accepts_nested_attributes_for :domain_contacts, allow_destroy: true
  accepts_nested_attributes_for :admin_domain_contacts,
                                allow_destroy: true, reject_if: :admin_change_prohibited?
  accepts_nested_attributes_for :tech_domain_contacts,
                                allow_destroy: true, reject_if: :tech_change_prohibited?

  has_many :nameservers, dependent: :destroy, inverse_of: :domain
  accepts_nested_attributes_for :nameservers, allow_destroy: true,
                                              reject_if: proc { |attrs| attrs[:hostname].blank? }

  has_many :dnssec_keys, dependent: :destroy
  accepts_nested_attributes_for :dnssec_keys, allow_destroy: true, reject_if: :all_blank

  belongs_to :registrant, class_name: 'Contact', foreign_key: :registrant_id

  validates :domain_contacts, length: { minimum: Tld::Estonian::MIN_DOMAIN_CONTACT_COUNT,
                                        message: I18n.t('.min_domain_contacts',
                                                        number: Tld::Estonian::MIN_DOMAIN_CONTACT_COUNT) }
  # validates :nameservers, length: { minimum: Tld::Estonian::MIN_NAMESERVER_COUNT,
  #                                   message: I18n.t('.min_nameservers', number: Tld::Estonian::MIN_NAMESERVER_COUNT) }

  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-\.]+\z/ }

  def self.build_from_registrar(registrar)
    new
  end

  def reserved_pw
    information['reserved_pw'] if information
  end

  def reserved_pw=(value)
    self.information = (information || {}).merge('reserved_pw' => value)
  end

  def registry_created_at
    metadata['registry_created_at'] if metadata
  end

  def registry_updated_at
    metadata['registry_updated_at'] if metadata
  end
end
