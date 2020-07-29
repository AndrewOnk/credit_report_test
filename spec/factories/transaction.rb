FactoryBot.define do
  factory :transaction do
    transaction_type {'Set'}
    amount { 1000.00 }
    credit_report
  end
end