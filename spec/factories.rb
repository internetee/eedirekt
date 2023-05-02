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
    crt {}
    key {}
  end

  factory :estonian_tld, class: 'Tld::Estonian' do
    username { 'oleghasjanov' }
    base_url { 'http://registry:3000' }
    password { '123456' }
    type { 'Tld::Estonian' }
    crt {}
    key {}
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
    ipv6 { [] }
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
end
