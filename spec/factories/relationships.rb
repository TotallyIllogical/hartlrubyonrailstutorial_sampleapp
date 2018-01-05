FactoryGirl.define do
  factory :relationship do

    trait :one do
      follower { Factory(:user,:arthur) }
      followed { Factory(:user,:ford) }
    end

    trait :two do
      follower { Factory(:user,:arthur) }
      followed { Factory(:user,:trillian) }
    end

    trait :three do
      follower { Factory(:user,:ford) }
      followed { Factory(:user,:arthur) }
    end

    trait :four do
      follower { Factory(:user,:zaphod) }
      followed { Factory(:user,:arthur) }
    end

  end
end
