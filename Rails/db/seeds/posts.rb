User.limit(10).each do |user|
    post = user.posts.create!(body: Faker::Hacker.say_something_smart, images: %w[https://picsum.photos/350/350/?random https://picsum.photos/350/350/?random])
end
