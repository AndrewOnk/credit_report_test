require 'rails_helper'

RSpec.describe Operations::CreateTransaction do
  let(:limit_transaction_string) { "Limit $800" }
  let(:charge_transaction_string) { "Charge $400" }
  let(:add_transaction_string) { "Add $100" }
  let(:credit_report) { FactoryBot.create(:credit_report, limit: 800) }

  describe 'initialize' do
    describe 'extracts t_type' do
      it 'Limit' do
        create_transaction = Operations::CreateTransaction.new(limit_transaction_string)
        expect(create_transaction.t_type).to eq('Limit')
      end

      it 'Charge' do
        create_transaction = Operations::CreateTransaction.new(charge_transaction_string)
        expect(create_transaction.t_type).to eq('Charge')
      end

      it 'Add' do
        create_transaction = Operations::CreateTransaction.new(add_transaction_string)
        expect(create_transaction.t_type).to eq('Add')
      end
    end

    describe 'extracts amount' do
      it '$800' do
        create_transaction = Operations::CreateTransaction.new("Limit $800" )
        expect(create_transaction.amount).to eq(800.00)
      end

      it '$800.00' do
        create_transaction = Operations::CreateTransaction.new("Limit $800.00" )
        expect(create_transaction.amount).to eq(800.00)
      end

      it '€800' do
        create_transaction = Operations::CreateTransaction.new("Limit €800")
        expect(create_transaction.amount).to eq(800.00)
      end
    end
  end

  describe '#new_transaction_model' do

    it 'creates Set transaction for Limit $800 line' do
      create_transaction = Operations::CreateTransaction.new(limit_transaction_string)
      create_transaction.new_transaction_model(credit_report)
      expect(create_transaction.transaction.transaction_type).to eq('Set')
      expect(create_transaction.transaction.amount).to eq(800.00)
    end

    it 'creates Charge transaction for Charge $400 line' do
      create_transaction = Operations::CreateTransaction.new(charge_transaction_string)
      create_transaction.new_transaction_model(credit_report)
      expect(create_transaction.transaction.transaction_type).to eq('Charge')
      expect(create_transaction.transaction.amount).to eq(400.00)
    end

    it 'creates Add transaction for Add $100 line' do
      create_transaction = Operations::CreateTransaction.new(add_transaction_string)
      create_transaction.new_transaction_model(credit_report)
      expect(create_transaction.transaction.transaction_type).to eq('Add')
      expect(create_transaction.transaction.amount).to eq(100.00)
    end
  end

  describe '#call' do
    it 'saves transaction' do
      create_transaction = Operations::CreateTransaction.new(limit_transaction_string)
      create_transaction.new_transaction_model(credit_report)
      transaction = Transaction.find_by(transaction_type: 'Set', amount: 800.00)
      expect(transaction).to be_falsey
      create_transaction.call
      transaction = Transaction.find_by(transaction_type: 'Set', amount: 800.00)
      expect(transaction).to be_truthy
    end
  end
end