class Contact < ApplicationRecord
  include EstTld::Roles
  include EstTld::Country
  include EstTld::LegalDoc
  include EstTld::Statuses
  include Contact::Searchable
  include Phone

  attr_accessor :phone_code

  has_many :domain_contacts
  has_many :domains, through: :domain_contacts

  enum state: { draft: 0, active: 1 }

  store_accessor :information,
                 :address,
                 :statuses,
                 :registrar,
                 :metadata

  validates :ident, uniqueness: { scope: :country_code }, allow_blank: true
  validate :identity_code_must_be_valid_for_estonia, if: proc { |user|
    user.country_code.present? && user.country_code == 'EE'
  }

  validates :phone, presence: true, numericality: { only_integer: true }
  validates :phone_code, presence: true, numericality: { only_integer: true }
  before_save :combine_phone_and_phone_code
  after_find :split_phone_into_code_and_number

  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: I18n.t('.invalid_email_format') }
  validates :name, presence: true
  validates :role, inclusion: { in: Contact.roles }
  
  def self.create_contact_from_registrant_perform_later(registrant_user:)
    c = Contact.find_by(ident: registrant_user.ident)
    return c if c && c.code.present?

    CreateContactJob.perform_later(registrant_user)
  end

  def self.search(query)
    where('name ILIKE ? OR code ILIKE ?', "%#{query}%", "%#{query}%")
  end

  def identity_code_must_be_valid_for_estonia
    return if EstonianTld::IdentityCode::Estonia.new(country_code, ident).valid?

    errors.add(:ident, I18n.t(:is_invalid))
  end

  def zip
    address['zip'] if address
  end

  def zip=(value)
    self.address = (address || {}).merge('zip' => value)
  end

  def city
    address['city'] if address
  end

  def city=(value)
    self.address = (address || {}).merge('city' => value)
  end

  def state_address
    address['state_address'] if address
  end

  def state_address=(value)
    self.address = (address || {}).merge('state_address' => value)
  end

  def street
    address['street'] if address
  end

  def street=(value)
    self.address = (address || {}).merge('street' => value)
  end

  def address_country_code
    address['country_code'] if address
  end

  def address_country_code=(value)
    self.address = (address || {}).merge('country_code' => value)
  end

  def registrar_name
    registrar['name'] if registrar
  end

  def registrar_name=(value)
    self.registrar = (registrar || {}).merge('name' => value)
  end

  def registrar_website
    registrar['website'] if registrar
  end

  def registrar_website=(value)
    self.registrar = (registrar || {}).merge('website' => value)
  end

  def postal_address
    "#{street}, #{city}, #{state_address}, #{zip}, #{address_country_code}"
  end

  def registry_created_at
    metadata['registry_created_at'] if metadata
  end

  def registry_updated_at
    metadata['registry_updated_at'] if metadata
  end

  def to_s
    "#{name} - #{code}"
  end
end
