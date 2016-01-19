FactoryGirl.define do
  factory :user, class: DeviseApi::User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 123_456
    password_confirmation 123_456
  end
end
