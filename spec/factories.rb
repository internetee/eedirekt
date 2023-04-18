FactoryBot.define do
  factory :super_user do
    username { Faker::Name.name.gsub(' ', '_').underscore }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :registrar_user do
    name { Faker::Name.name }
    code { '30303039914'}
    username { Faker::Name.name.gsub(' ', '_').underscore }
    password { Faker::Internet.password }
  end

  factory :user do
    name { Faker::Name.name }
    code { '30303039914'}
  end
end
