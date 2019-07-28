# db:createtask
namespace :db do
  desc "Create task"
  task :createtask => :environment do
    FactoryBot.define do
      factory :taskorder do
        title { Faker::Lorem.sentence }
        content { Faker::Lorem.paragraph }
        start_at { DateTime.now - rand(1..3) }
        deadline_at { DateTime.now + rand(1..3) }
        priority { rand 0..2 }
        status { rand 0..2 }
      end
    end

    10.times{
      Task.create(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, start_at: DateTime.now - rand(1..3), deadline_at: DateTime.now + rand(1..3), priority: rand(0..2), status: rand(0..2), created_at: DateTime.now - rand(3..10))
    }

  end
end