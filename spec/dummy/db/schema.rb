# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140128012354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comable_cart_items", force: true do |t|
    t.integer "customer_id",             null: false
    t.integer "product_id",              null: false
    t.integer "quantity",    default: 1, null: false
  end

  add_index "comable_cart_items", ["customer_id", "product_id"], name: "index_comable_cart_items_on_customer_id_and_product_id", unique: true, using: :btree

  create_table "comable_orders", force: true do |t|
    t.integer  "customer_id", null: false
    t.string   "code",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string "family_name", null: false
    t.string "first_name",  null: false
  end

  create_table "products", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",       null: false
    t.integer  "price"
    t.text     "caption"
  end

end
