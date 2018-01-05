FactoryGirl.define do
  factory :user do

    sequence :name do |n|
      "#{Faker::HitchhikersGuideToTheGalaxy.character}#{n}"
    end

    sequence(:email) { |n| "tester#{n}@example.com" }

    password_digest User.digest('password')
    activated true
    activated_at Time.zone.now

    trait :admin do
      name "Admin User"
      email "admin@example.com"
      admin true
    end

    trait :arthur do
      name "Arthur Dent"
      email "arthur@heartofgold.ship"
    end

    trait :ford do
      name "Ford Prefect"
      email "ford@heartofgold.ship"
    end

    trait :trillian do
      name "Tricia Marie McMillan"
      email "trillian@heartofgold.ship"
    end

    trait :zaphod do
      name "Zaphod Beeblebrox"
      email "zaphod@heartofgold.ship"
    end

  end
end
