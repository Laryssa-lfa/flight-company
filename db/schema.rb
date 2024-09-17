# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_16_153318) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string "iata"
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destinations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flight_details", force: :cascade do |t|
    t.string "origin"
    t.string "destiny"
    t.string "origin_airport"
    t.string "destination_airport"
    t.integer "flight_number"
    t.string "name_airline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "departure_time"
    t.datetime "arrival_time"
  end

  create_table "flights", force: :cascade do |t|
    t.integer "fare_category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer "air_miles"
    t.string "currency"
    t.decimal "value", precision: 10, scale: 2
    t.string "formatted_price"
    t.bigint "flight_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_id"], name: "index_prices_on_flight_id"
  end

  create_table "related_connections", force: :cascade do |t|
    t.bigint "flight_detail_id", null: false
    t.bigint "flight_id", null: false
    t.integer "connection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_detail_id"], name: "index_related_connections_on_flight_detail_id"
    t.index ["flight_id"], name: "index_related_connections_on_flight_id"
  end

  add_foreign_key "prices", "flights"
  add_foreign_key "related_connections", "flight_details"
  add_foreign_key "related_connections", "flights"
end
