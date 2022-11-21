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

ActiveRecord::Schema.define(version: 20160806201125) do

  create_table "decisions", force: :cascade do |t|
    t.integer  "team_round_id", limit: 4
    t.integer  "input_item_id", limit: 4
    t.string   "value",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "input_items", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "identifier",      limit: 255
    t.string   "label",           limit: 255
    t.string   "kind",            limit: 255
    t.integer  "input_screen_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.float    "default_value",   limit: 24
  end

  create_table "input_screens", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "navigation_label", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "identifier",       limit: 255
  end

  create_table "inputs", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "kind",            limit: 255
    t.string   "label",           limit: 255
    t.integer  "min",             limit: 4
    t.integer  "max",             limit: 4
    t.string   "string_default",  limit: 255
    t.string   "integer_default", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "round_input_screens", force: :cascade do |t|
    t.integer  "round_id",        limit: 4
    t.integer  "input_screen_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.integer  "round_number",               limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "simulation_id",              limit: 4
    t.string   "economic_data_file_name",    limit: 255
    t.string   "economic_data_content_type", limit: 255
    t.integer  "economic_data_file_size",    limit: 4
    t.datetime "economic_data_updated_at"
    t.string   "debrief_file_name",          limit: 255
    t.string   "debrief_content_type",       limit: 255
    t.integer  "debrief_file_size",          limit: 4
    t.datetime "debrief_updated_at"
  end

  create_table "simulations", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "number_of_rounds", limit: 4
  end

  create_table "team_rounds", force: :cascade do |t|
    t.integer  "team_id",              limit: 4
    t.integer  "round_id",             limit: 4
    t.boolean  "is_finished"
    t.datetime "finish_date"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "report_file_name",     limit: 255
    t.string   "report_content_type",  limit: 255
    t.integer  "report_file_size",     limit: 4
    t.datetime "report_updated_at"
    t.string   "debrief_file_name",    limit: 255
    t.string   "debrief_content_type", limit: 255
    t.integer  "debrief_file_size",    limit: 4
    t.datetime "debrief_updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "password",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
