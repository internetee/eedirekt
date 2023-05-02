class Nameserver < ApplicationRecord
  belongs_to :domain, required: true
end
