FactoryGirl.define do
  factory :user do
    sequence(:username) { |i| "user#{i}" }
    email { "#{username}@example.com" }
    password 'password1234'
  end

  factory :asset do
    sequence(:title) { |i| "Asset ##{i}" }
  end
end
