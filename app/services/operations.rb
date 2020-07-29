class Operations

  attr_reader :body, :transactions, :errors

  def initialize(body)
    @body = body.strip
    @errors = []
    get_transactions
  end

  def call
    @transactions.each(&:call)
  end

  private

  def get_transactions
    @transactions = @body.split(/\n+/).map do |transaction_line|
      split_line = Operations::SplitTransactionLine.new(transaction_line)
      if split_line.errors.present?
        @errors += split_line.errors
        next
      end

      user = get_user(split_line.name)
      transaction = Operations::CreateTransaction.new(split_line.transaction_string)
      credit_report = get_credit_report(split_line.uuid, user, transaction)
      transaction.new_transaction_model(credit_report)
      unless transaction.valid?
        @errors += transaction.errors
        next
      end
      transaction
    end.compact
  end

  def get_user(name)
    name_array = name.strip.split(' ')
    User.find_or_create_by(first_name: name_array.first, last_name: name_array.last)
  end

  def get_credit_report(uuid, user, transaction)
    return CreditReport.find_or_create_by(uuid: uuid, user: user, limit: transaction.amount) if transaction.t_type == 'Limit'

    CreditReport.find_by(uuid: uuid)
  end
end