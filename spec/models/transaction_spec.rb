require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:credit_report) }
  end

  describe 'validations' do
    it { validate_presence_of(:credit_report) }
    it { validate_presence_of(:amount) }
    it { validate_presence_of(:transaction_type) }
    it { validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end
end
