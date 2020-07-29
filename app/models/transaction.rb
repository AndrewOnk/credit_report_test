class Transaction < ApplicationRecord
  belongs_to :credit_report

  enum transaction_type: %w[Set Charge Add]

  validates_presence_of :credit_report, :amount, :transaction_type
end
