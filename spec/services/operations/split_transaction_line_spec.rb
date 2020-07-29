require 'rails_helper'

RSpec.describe Operations::SplitTransactionLine do
  let(:transaction_line) { "Bob Doe 1001001234 Limit $800" }
  let(:operations) { Operations::SplitTransactionLine.new(transaction_line) }

  describe 'initialize' do
    it 'gets user name' do
      expect(operations.name).to eq('Bob Doe')
    end

    it 'gets uuid' do
      expect(operations.uuid).to eq('1001001234')
    end

    it 'gets transaction_string' do
      expect(operations.transaction_string).to eq('Limit $800')
    end
  end
end