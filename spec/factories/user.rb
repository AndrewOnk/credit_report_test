FactoryBot.define do
  factory :user do
    sequence(:first_name)
    sequence(:last_name)
  end
end