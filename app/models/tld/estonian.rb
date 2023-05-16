class Tld::Estonian < Tld
  has_one_attached :crt
  has_one_attached :key

  MIN_DOMAIN_CONTACT_COUNT = 2
  MIN_NAMESERVER_COUNT = 2

  def self.permitted_attributes
    %i[username password crt key base_url]
  end
end
