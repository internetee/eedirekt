class Tld::Estonian < Tld
  has_one_attached :crt
  has_one_attached :key

  def self.permitted_attributes
    %i[username password crt key base_url]
  end
end
