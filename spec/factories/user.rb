FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    password { '111111' }
    password_confirmation { '111111' }
    email { Faker::Internet.email }
    role { rand 0..1 }
  end
end