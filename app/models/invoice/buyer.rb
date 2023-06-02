module Invoice::Buyer
  extend ActiveSupport::Concern

  included do
    store_accessor :buyer_data, :name
    store_accessor :buyer_data, :ident
    store_accessor :buyer_data, :country_code
    store_accessor :buyer_data, :state
    store_accessor :buyer_data, :street
    store_accessor :buyer_data, :city
    store_accessor :buyer_data, :zip
    store_accessor :buyer_data, :phone
    store_accessor :buyer_data, :url
    store_accessor :buyer_data, :email
  end

end
