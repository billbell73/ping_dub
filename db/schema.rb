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

ActiveRecord::Schema.define(version: 20140414143327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_id"
    t.boolean  "p1_started_game_serving"
    t.boolean  "p1_partners_in_id_order"
    t.boolean  "p2_partners_in_id_order"
  end

  add_index "games", ["match_id"], name: "index_games_on_match_id", using: :btree
  add_index "games", ["winner_id"], name: "index_games_on_winner_id", using: :btree

  create_table "matches", force: true do |t|
    t.integer  "winner_id"
    t.integer  "p1_id"
    t.integer  "p2_id"
    t.boolean  "doubles_match"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "best_of"
    t.boolean  "p1_starts_left"
    t.boolean  "p1_first_server"
  end

  add_index "matches", ["p1_id"], name: "index_matches_on_p1_id", using: :btree
  add_index "matches", ["p2_id"], name: "index_matches_on_p2_id", using: :btree
  add_index "matches", ["winner_id"], name: "index_matches_on_winner_id", using: :btree

  create_table "parties", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "party_id"
  end

  add_index "players", ["party_id"], name: "index_players_on_party_id", using: :btree

  create_table "points", force: true do |t|
    t.integer "winner_id"
    t.integer "server_id"
    t.boolean "p1_on_left"
    t.integer "game_id"
  end

  add_index "points", ["game_id"], name: "index_points_on_game_id", using: :btree
  add_index "points", ["server_id"], name: "index_points_on_server_id", using: :btree
  add_index "points", ["winner_id"], name: "index_points_on_winner_id", using: :btree

end
