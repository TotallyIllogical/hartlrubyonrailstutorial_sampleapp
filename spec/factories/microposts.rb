FactoryGirl.define do
  factory :micropost do

    content Faker::HitchhikersGuideToTheGalaxy.quote
    created_at 3.hours.ago
    user :admin

    trait :created_two_hours_ago do
      created_at 1.hour.ago
    end

    trait :created_a_week_ago do
      created_at 1.week.ago
    end

    trait :created_now do
      created_at Time.zone.now
    end

    trait :without_content do
      content nil
    end

    trait :without_user do
      user nil
    end

    trait :with_other_user do
      user :arthur
    end

    trait :with_picture do
      picture { File.new("#{Rails.root}/spec/files/kitten.jpg") }
    end

  end
end
