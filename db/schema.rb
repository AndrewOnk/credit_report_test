# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_28_073322) do

  create_table "credit_reports", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "uuid"
    t.decimal "limit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_credit_reports_on_user_id"
  end

  create_table "limits", force: :cascade do |t|
    t.integer "user_id"
    t.integer "amount", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_limits_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "type"
    t.decimal "amount"
    t.integer "credit_report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["credit_report_id"], name: "index_transactions_on_credit_report_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "credit_reports", "users"
  add_foreign_key "limits", "users"
  add_foreign_key "transactions", "credit_reports"
end
