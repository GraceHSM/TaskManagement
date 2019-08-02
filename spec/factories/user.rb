FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    password { '111111' }
    email { Faker::Internet.email }
    role { 0 }
  end
end