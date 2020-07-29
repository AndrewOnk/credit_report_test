require 'rails_helper'

RSpec.describe Api::OperationsController, type: :controller do
  describe 'POST create' do
    let(:json_payload) {
      {
        "body": "Bob Doe 1001001234 Limit $800\n Jane Doe 1001001235 Limit $500\nBob Doe 1001001234 Charge $400\nJane Doe 1001001235 Charge $300\nBob Doe 1001001234 Add $100"
      }
    }
    let(:xml_payload) {
      '<?xml version="1.0" encoding="UTF-8"?>
          <data>
              <body>
                  Bob Doe 1001001234 Limit $800
                  Jane Doe 1001001235 Limit $500
                  Bob Doe 1001001234 Charge $400
                  Jane Doe 1001001235 Charge $300
                  Bob Doe 1001001234 Add $100
              </body>
          </data>'
    }
    it 'returns quantity of created transaction from json payload' do
      post :create, params: {data: json_payload, format: :json}

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(201)
      body = JSON.parse(response.body)
      expect(body['transactions_created']).to eq(5)
    end

    xit 'returns quantity of created transaction from xml payload' do
      request.env['content_type'] = 'application/xml'

      post :create, body: xml_payload, format: :xml

      expect(response.content_type).to eq("application/xml; charset=utf-8")
      expect(response).to have_http_status(201)
      body = JSON.parse(response.body)
      expect(body['transactions_created']).to eq(5)
    end
  end
end