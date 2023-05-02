class Contact < ApplicationRecord
  include EstTldRoles

  has_many :domain_contacts
  has_many :domains, through: :domain_contacts
end
