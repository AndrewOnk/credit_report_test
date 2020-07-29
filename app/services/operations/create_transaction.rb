class Operations
  class CreateTransaction

    attr_reader :t_type, :amount, :transaction, :errors

    def initialize(transaction_string)
      @errors = []

      @t_type, amount = transaction_string.split(' ')
      @amount = amount.gsub(/[^\d,\.]/,'').to_f
    end

    def new_transaction_model(credit_report)
      type = @t_type == 'Limit' ? 'Set' : @t_type
      @transaction = Transaction.new(transaction_type: type, amount:  @amount, credit_report: credit_report)
    rescue ArgumentError => e
      @errors.push(e.message)
    end

    def call
      @transaction.save
    end

    def valid?
      if @transaction && !@transaction.valid?
        @errors.push(@transaction.errors.full_messages)
      end

      @errors.empty?
    end
  end
end