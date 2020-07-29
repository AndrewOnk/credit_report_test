require 'rails_helper'

RSpec.describe Operations do
  let(:body) {
    %Q(Bob Doe 1001001234 Limit $800
    Jane Doe 1001001235 Limit $500
    Bob Doe 1001001234 Charge $400
    Jane Doe 1001001235 Charge $300
    Bob Doe 1001001234 Add $100)
  }
  let(:operations) { Operations.new(body) }

  describe '#call' do
    it 'creates users' do
      bob = User.find_by(first_name: 'Bob', last_name: 'Doe')
      jane = User.find_by(first_name: 'Jane', last_name: 'Doe')
      expect(bob).to be_falsey
      expect(jane).to be_falsey
      operations.call
      bob = User.find_by(first_name: 'Bob', last_name: 'Doe')
      jane = User.find_by(first_name: 'Jane', last_name: 'Doe')
      expect(bob).to be_truthy
      expect(jane).to be_truthy
    end

    it 'does not create user when he exists in DB' do
      User.create(first_name: 'Bob', last_name: 'Doe')
      operations.call
      users = User.where(first_name: 'Bob', last_name: 'Doe')
      expect(users.size).to eq(1)
    end

    it 'creates credit_reports for users' do
      bobs_credit_report = CreditReport.find_by(uuid: '1001001234')
      jane_credit_report = CreditReport.find_by(uuid: '1001001235')
      expect(bobs_credit_report).to be_falsey
      expect(jane_credit_report).to be_falsey
      operations.call
      bobs_credit_report = CreditReport.find_by(uuid: '1001001234')
      jane_credit_report = CreditReport.find_by(uuid: '1001001235')
      expect(bobs_credit_report).to be_truthy
      expect(jane_credit_report).to be_truthy
    end

    it 'creates transactions' do
      bobs_set_transaction = Transaction.find_by(transaction_type: 'Set', amount: 800.00)
      bobs_charge_transaction = Transaction.find_by(transaction_type: 'Charge', amount: 400.00)
      bobs_add_transaction = Transaction.find_by(transaction_type: 'Add', amount: 100.00)
      expect(bobs_set_transaction).to be_falsey
      expect(bobs_charge_transaction).to be_falsey
      expect(bobs_add_transaction).to be_falsey

      jane_set_transaction = Transaction.find_by(transaction_type: 'Set', amount: 500.00)
      jane_charge_transaction = Transaction.find_by(transaction_type: 'Charge', amount: 300.00)
      expect(jane_set_transaction).to be_falsey
      expect(jane_charge_transaction).to be_falsey

      operations.call

      bobs_set_transaction = Transaction.find_by(transaction_type: 'Set', amount: 800.00)
      bobs_charge_transaction = Transaction.find_by(transaction_type: 'Charge', amount: 400.00)
      bobs_add_transaction = Transaction.find_by(transaction_type: 'Add', amount: 100.00)
      expect(bobs_set_transaction).to be_truthy
      expect(bobs_charge_transaction).to be_truthy
      expect(bobs_add_transaction).to be_truthy

      jane_set_transaction = Transaction.find_by(transaction_type: 'Set', amount: 500.00)
      jane_charge_transaction = Transaction.find_by(transaction_type: 'Charge', amount: 300.00)
      expect(jane_set_transaction).to be_truthy
      expect(jane_charge_transaction).to be_truthy
    end

  end
end