class Operations
  class SplitTransactionLine
    UUID_LENGTH = 10
    SPLIT_SIZE = 3

    attr_reader :errors, :name, :uuid, :transaction_string

    def initialize(transaction_line)
      @transaction_line = transaction_line
      @errors = []

      unless @transaction_line.class == String
        @errors.push(error_message)
        return
      end

      split_array = @transaction_line.split(/\s(\d{#{UUID_LENGTH}})\s/)
      if split_array.size != SPLIT_SIZE || split_array.any?(&:blank?)
        @errors.push(error_message)
        return
      end
      @name, @uuid, @transaction_string = split_array
    end

    private

    def error_message
      "Invalid transaction line: #{@transaction_line}"
    end
  end
end