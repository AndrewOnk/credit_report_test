FactoryBot.define do
  factory :credit_report do
    user
    sequence(:uuid) { |n| "100100123#{n}" }
    limit { 1000.00 }
  end
end