class Nameserver < ApplicationRecord
  belongs_to :domain, required: true

  # validates :hostname, :ipv4, :ipv6, presence: true

  def ipv4=(value)
    super value.split(',')
  end

  def ipv6=(value)
    super value.split(',')
  end
end
