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
User.create!(name: "Jack O'Neill",
             email: "jack@stargate.gov",
             password: "123456",
             password_confirmation: "123456",
             activated: true,
             activated_at: Time.zone.now)
User.create!(name: "Samantha Carter",
             email: "samantha@stargate.gov",
             password: "123456",
             password_confirmation: "123456",
             activated: true,
             activated_at: Time.zone.now)
User.create!(name: "Daniel Jackson",
             email: "daniel@stargate.gov",
             password: "123456",
             password_confirmation: "123456",
             activated: true,
             activated_at: Time.zone.now)
User.create!(name: "Teal'c Alien",
             email: "tealc@stargate.gov",
             password: "123456",
             password_confirmation: "123456",
             activated: true,
             activated_at: Time.zone.now)
64.times do |n|
  name  = Faker::Name.name
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
new_users = []
users.each do |user|
  if user.id.between?(6,12)
    new_users.push(user)
  end
end
50.times do
  content = Faker::ChuckNorris.fact
  if content.length > 140 
   content[0..140]
  end
  new_users.each { |user| user.microposts.create!(content: content)}
end

admin = User.first
admin.microposts.create!(content: "This is my first post")
admin.microposts.create!(content: "Hello World!")

jack = User.find_by(id: 2)
jack.microposts.create!(content: "Oh for crying out loud!")
jack.microposts.create!(content: "I'd like to apologize in advance for anything I may say, or do, that could be construed as offensive, as I slowly go NUTS!")
jack.microposts.create!(content: "I guess I'm supposed to say something... profound.")

samantha = User.find_by(id: 3)
samantha.microposts.create!(content: "Holy Hannah")
samantha.microposts.create!(content: "You know, you blow up one sun and suddenly everyone expects you to walk on water.")
samantha.microposts.create!(content: "It took us 15 years and three supercomputers to MacGyver a system for the gate on Earth.")

daniel = User.find_by(id: 4)
daniel.microposts.create!(content: "Anyone got a tissue?")
daniel.microposts.create!(content: "A fool's paradise is a wise man's hell.")
daniel.microposts.create!(content: "Why so quick to jump to the conclusion that I'm crazy? That I'm dangerous and out of control? It's cause I'm acting that way, aren't I?")

tealc = User.find_by(id: 5)
tealc.microposts.create!(content: "In my culture, I would be well within my rights to dismember you.")
tealc.microposts.create!(content: "If you once again try to harm me or one of my companions, my patience with you will expire.")
tealc.microposts.create!(content: "Indeed")