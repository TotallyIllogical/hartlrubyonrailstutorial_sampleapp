# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "Tess Teir",
             email: "example@railstutorial.org",
             password: "123456",
             password_confirmation: "123456",
             activated: true,
             activated_at: Time.zone.now,
             admin: true)
49.times do |n|
  name  = Faker::HitchhikersGuideToTheGalaxy.character
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Sort user list by created at and take the first 6
users = User.order(:created_at)
50.times do
  content = Faker::HitchhikersGuideToTheGalaxy.quote
  if content.length > 140
   content = content[0..139]
  end
  users.each { |user| user.microposts.create!(content: content)}
end

admin = User.first
admin.microposts.create!(content: "This is my first post")
admin.microposts.create!(content: "Hello World!")

users = User.all
user = users.first
following = users[2..5]
followers = users[2..4]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }