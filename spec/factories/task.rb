FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_at { DateTime.now - rand(2..4) }
    deadline_at { DateTime.now + 1 }
    priority { rand 0..2 }
    status { rand 0..2 }
    user_id { User.last.id }
  end
end