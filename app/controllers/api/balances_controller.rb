module Api
  class BalancesController < ApplicationController
    def index
      respond_to do |format|
        format.json { render json: balances.to_json, status: :ok }
        format.xml { render xml: balances.to_xml(root: 'data'), status: :ok }
      end
    end

    private

    def balances
      User.all.map do |user|
        {"#{user.first_name} #{user.last_name}": user.balance}
      end
    end
  end
end
