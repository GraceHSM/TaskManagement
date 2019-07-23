FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_at { DateTime.new - rand(1..3) }
    deadline_at { DateTime.new + rand(1..3) }
    priority { rand 0..3 }
    status { rand 0..2 }
  end
end