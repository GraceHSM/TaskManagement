FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_at { DateTime.now - rand(2..4) }
    deadline_at { DateTime.now + rand(2..4) }
    created_at { DateTime.now - rand(4..10) }
    priority { rand 0..2 }
    status { rand 0..2 }
  end
end