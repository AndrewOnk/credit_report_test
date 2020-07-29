module Api
  class OperationsController < ApplicationController
    def create
      @operations = Operations.new(filtered_params[:body])
      
      if @operations.errors.present?
        payload = { errors: @operations.errors }
        respond_to do |format|
          format.json { render json: payload.to_json, status: :unprocessable_entity }
          format.xml { render xml: payload.to_xml(root: 'data'), status: :unprocessable_entity }
        end
      else
        @operations.call
        payload = { transactions_created: @operations.transactions.size }
        respond_to do |format|
          format.json { render json: payload.to_json, status: :created }
          format.xml { render xml: payload.to_xml(root: 'data'), status: :created }
        end
      end
    end

    private

    def filtered_params
      params.require(:data).permit(:body)
    end
  end
end