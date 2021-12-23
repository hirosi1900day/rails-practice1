FactoryBot.define do
    factory :comment do
      body { Faker::Hacker.say_something_smart }
      user
      post
    end
end