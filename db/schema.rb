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

ActiveRecord::Schema.define(version: 20141128095807) do

  create_table "buildings", force: true do |t|
    t.integer  "town_id"
    t.integer  "created_by_id"
    t.text     "note"
    t.string   "title"
    t.text     "area"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color",         default: "8ae234"
  end

  create_table "height_maps", force: true do |t|
    t.integer  "town_id"
    t.text     "area"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "herbalism_list_items", force: true do |t|
    t.integer  "herbalism_list_id"
    t.integer  "herb_id"
    t.integer  "first_effect_id",   default: 0
    t.integer  "second_effect_id",  default: 0
    t.integer  "third_effect_id",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "herbalism_lists", force: true do |t|
    t.string   "server"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "herbs", force: true do |t|
    t.string   "name"
    t.string   "img_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pending_invites", force: true do |t|
    t.integer  "town_id"
    t.integer  "user_id"
    t.integer  "invited_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_items", force: true do |t|
    t.integer  "todo_list_id"
    t.string   "title"
    t.text     "note"
    t.integer  "assigned_to_id"
    t.integer  "created_by_id"
    t.integer  "order"
    t.boolean  "completed",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_lists", force: true do |t|
    t.integer  "town_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "towns", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "townsmen", force: true do |t|
    t.integer  "town_id"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "rank"
    t.integer  "herbalism_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
