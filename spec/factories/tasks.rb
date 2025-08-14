FactoryBot.define do
  factory :task do
    name { "MyString" }
    description { "MyText" }
    status { 1 }
    due_date { "2025-08-12 00:54:18" }
    project { nil }
  end
end
