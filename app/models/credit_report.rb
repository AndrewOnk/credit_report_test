class CreditReport < ApplicationRecord
  belongs_to :user
  has_many :transactions
  BALANCE_OPERATIONS = {
    'Charge' => '-',
    'Add' => '+',
  }

  validates_presence_of :user, :uuid, :limit
  validates_numericality_of :limit, greater_than_or_equal_to: 0

  def balance
    balance = 0
    transactions.order(:created_at).each do |transaction|
      if transaction.transaction_type == 'Set'
        balance = transaction.amount
      else
        balance = balance.send(BALANCE_OPERATIONS[transaction.transaction_type].to_sym, transaction.amount)
      end
    end
    balance
  end
end
