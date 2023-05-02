class DomainContact < ApplicationRecord
  belongs_to :contact
  belongs_to :domain
end
