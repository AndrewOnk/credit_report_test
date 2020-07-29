require 'rails_helper'

RSpec.describe Api::BalancesController, type: :controller do
  describe 'GET index' do
    let(:body) {
      %Q(Bob Doe 1001001234 Limit $800
    Jane Doe 1001001235 Limit $500
    Bob Doe 1001001234 Charge $400
    Jane Doe 1001001235 Charge $300
    Bob Doe 1001001234 Add $100)
    }
    let(:operations) { Operations.new(body) }

    it 'returns balances for all users in json' do
      operations.call

      get :index, format: :json
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      bob = body.find {|h| h['Bob Doe']}
      expect(bob['Bob Doe']).to eq(["$500.00"])
    end

    it 'returns balances for all users in xml' do
      operations.call

      get :index, format: :xml
      expect(response.content_type).to eq("application/xml; charset=utf-8")
      expect(response).to have_http_status(200)
      hash = Hash.from_xml(response.body.gsub("\n", ""))
      bob = hash['data'].find {|h| h['Bob_Doe']}
      expect(bob['Bob_Doe']).to eq(["$500.00"])
    end
  end
end