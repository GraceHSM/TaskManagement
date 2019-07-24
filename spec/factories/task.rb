FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_at { DateTime.now - rand(1..3) }
    deadline_at { DateTime.now + rand(1..3) }
    priority { rand 0..2 }
    status { rand 0..2 }
  end
end