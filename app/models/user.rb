class User < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  has_many :credit_reports

  def balance
    credit_reports.map {|report| number_to_currency(report.balance)}
  end

  validates_presence_of :first_name, :last_name
end
