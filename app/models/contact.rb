class Contact < ApplicationRecord
  include EstTld::Roles
  include EstTld::Country
  include EstTld::LegalDoc

  has_many :domain_contacts
  has_many :domains, through: :domain_contacts

  store_accessor :information,
                 :address,
                 :statuses,
                 :registrar

  def self.search(query)
    where("name ILIKE ? OR ident ILIKE ?", "%#{query}%", "%#{query}%")
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

  def state
    address['state'] if address
  end

  def state=(value)
    self.address = (address || {}).merge('state' => value)
  end

  def street
    address['street'] if address
  end

  def street=(value)
    self.address = (address || {}).merge('street' => value)
  end

  def address_country_code
    address["country_code"] if address
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

  def to_s
    "#{name} - #{code}"
  end
end
