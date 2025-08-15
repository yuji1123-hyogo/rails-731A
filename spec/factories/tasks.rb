# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    status { :pending }
    due_date { 1.week.from_now }
    association :project

    trait :completed do
      status { :completed }
    end

    trait :overdue do
      due_date { 1.week.ago }
    end
  end
end
