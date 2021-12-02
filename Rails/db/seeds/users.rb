20.times do |n|
    User.create!(
        email: Faker::Internet.unique.email,
        password: "password",
        password_confirmation: "password"        
)
end