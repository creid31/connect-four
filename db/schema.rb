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

ActiveRecord::Schema.define(version: 20170805212734) do

  create_table "board_slots", force: :cascade do |t|
    t.integer "x_coordinate"
    t.integer "y_coordinate"
    t.integer "user_id"
    t.integer "game_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_record_id"], name: "index_board_slots_on_game_record_id"
    t.index ["user_id"], name: "index_board_slots_on_user_id"
  end

  create_table "game_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "num_rows"
    t.integer "num_cols"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "points", default: 0
    t.integer "color"
    t.integer "game_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "currently_playing", default: false
    t.index ["game_record_id"], name: "index_users_on_game_record_id"
  end

end
