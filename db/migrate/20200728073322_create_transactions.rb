class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type
      t.decimal :amount
      t.references :credit_report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
