# spec/factories/projects.rb
FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    association :user
  end
end
