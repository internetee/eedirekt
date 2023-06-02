FactoryBot.define do
  factory :super_user do
    username { Faker::Name.name.gsub(' ', '_').underscore }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :registrar_user do
    name { Faker::Name.name }
    code { '30303039914' }
    username { Faker::Name.name.gsub(' ', '_').underscore }
    password { Faker::Internet.password }
  end

  factory :user do
    name { Faker::Name.name }
    code { '30303039914' }
  end

  factory :tld do
    username { 'oleghasjanov' }
    base_url { 'http://registry:3000' }
    password { '123456' }
    type { 'Tld::Estonian' }
  end

  factory :estonian_tld, class: 'Tld::Estonian' do
    username { 'oleghasjanov' }
    base_url { 'http://registry:3000' }
    password { '123456' }
    type { 'Tld::Estonian' }
  end

  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    ident { '30303039914' }
    code { Faker::Code.asin }
    country_code { 'EE' }
    role { 'priv' }
  end

  factory :domain do
    name { 'example.com' }
    statuses { ['ok'] }
    remote_created_at { Time.now }
    remote_updated_at { Time.now }
    expire_at { Time.now + 1.year }
    information { {} }
    association :registrant, factory: :contact

    after(:build) do |domain|
      domain.domain_contacts << build(:admin_domain_contact, domain: domain)
      domain.domain_contacts << build(:tech_domain_contact, domain: domain)
      domain.nameservers << build(:nameserver, domain: domain)
      domain.nameservers << build(:nameserver, domain: domain)
      domain.dnssec_keys << build(:dnssec_key, domain: domain)
    end
  end

  factory :domain_contact do
    domain
    contact

    factory :admin_domain_contact do
      type { 'AdminDomainContact' }
    end

    factory :tech_domain_contact do
      type { 'TechDomainContact' }
    end
  end

  factory :nameserver do
    hostname { 'ns1.example.com' }
    ipv4 { ['127.0.0.1'] }
    ipv6 { ['2001:db8::1'] }
    domain
  end

  factory :dnssec_key do
    flags { 256 }
    protocol { 3 }
    algorithm { 5 }
    public_key do
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzgOkCron8kn2R6OTgU5w5G5L5t8Jn7CnzCsRslR2nPgvYO/O22ZuV7nB4LZj3q4qSgQ+N7IPe9DyF0tL..'
    end
    domain
  end

  factory :app_session do
    association :sessionable, factory: :user
  end

  factory :invoice do
    uuid { SecureRandom.uuid }
    number {  }
    description { Faker::Lorem.sentence }
    reference_number { Faker::Number.number(digits: 10) }
    vat_rate { }

    buyer_data {
      {
        name: Faker::Name.name,
        ident: Faker::Number.number(digits: 10),
        country_code: Faker::Address.country_code,
        state: Faker::Address.state,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        zip: Faker::Address.zip,
        phone: Faker::PhoneNumber.phone_number,
        url: Faker::Internet.url,
        email: Faker::Internet.email,
      }
    }

    association :buyer, factory: :contact

    issue_date { DateTime.current }
    cancel_date { DateTime.current + 10.days }
    due_date { DateTime.current + 30.days }

    status { 'issued' }

    total { Faker::Number.decimal(l_digits: 2, r_digits: 2) }

    after(:build) do |invoice|
      invoice.invoice_items << build(:invoice_item, invoice: invoice)
    end

    after(:create) do |invoice|
      invoice.save!
    end
  end

  factory :invoice_item do
    association :invoice

    description { Faker::Lorem.sentence }
    quantity { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    unit_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end

  factory :setting do
    sequence(:code) { |n| "code_#{n}" }
    value { "Some value" }
    group { "Some group" }
    format { "Some format" }
  end
  
end
