require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:credit_reports) }
  end

  describe 'validations' do
    it { validate_presence_of(:first_name) }
    it { validate_presence_of(:last_name) }
  end

  describe '#balance' do
    let!(:bob) { FactoryBot.create(:user, first_name: 'Bob', last_name: 'Doe') }

    let!(:bob_credit_report) do
      credit_report = FactoryBot.create(:credit_report, user: bob, uuid: '1001001234', limit: 800.00)
      FactoryBot.create(:transaction, credit_report: credit_report, transaction_type: 'Set', amount: 800.00)
      FactoryBot.create(:transaction, credit_report: credit_report, transaction_type: 'Charge', amount: 400.00)
      FactoryBot.create(:transaction, credit_report: credit_report, transaction_type: 'Add', amount: 100.00)
      credit_report
    end
    let!(:jane) { FactoryBot.create(:user, first_name: 'Jane', last_name: 'Doe') }
    let!(:jane_credit_report) do
      credit_report = FactoryBot.create(:credit_report, user: jane, uuid: '1001001235', limit: 500.00)
      FactoryBot.create(:transaction, credit_report: credit_report, transaction_type: 'Set', amount: 500.00)
      FactoryBot.create(:transaction, credit_report: credit_report, transaction_type: 'Charge', amount: 300.00)
      credit_report
    end

    it 'calculates balance for Bob Doe' do
      expect(bob.balance).to eq(["$500.00"])
    end

    it 'calculates balance for Jane Doe' do
      expect(jane.balance).to eq(["$200.00"])
    end
  end
end
