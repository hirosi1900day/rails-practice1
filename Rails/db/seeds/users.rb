puts 'Start inserting seed "users" ...'
20.times do |n|
    User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.unique.email,
        password: "password",
        password_confirmation: "password"        
    )
    
end