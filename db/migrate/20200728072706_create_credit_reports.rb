class CreateCreditReports < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :uuid
      t.decimal :limit

      t.timestamps
    end
  end
end
