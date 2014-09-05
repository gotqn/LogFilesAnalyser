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

ActiveRecord::Schema.define(version: 20140905181645) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_files", force: true do |t|
    t.string   "json"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "log_file_id"
  end

  create_table "gpus", force: true do |t|
    t.string   "UDID"
    t.string   "name"
    t.string   "vendorID"
    t.integer  "log_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gpus", ["log_file_id"], name: "index_gpus_on_log_file_id", using: :btree

  create_table "graphics_processing_unit_stats", force: true do |t|
    t.string   "average"
    t.integer  "accepted"
    t.integer  "rejected"
    t.integer  "hardware_errors"
    t.string   "work_utility"
    t.string   "last_five_seconds"
    t.integer  "GraphicsProcessingUnit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphics_processing_units", force: true do |t|
    t.string   "name"
    t.integer  "log_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graphics_processing_units", ["log_file_id"], name: "index_graphics_processing_units_on_log_file_id", using: :btree

  create_table "log_event_types", force: true do |t|
    t.string   "event_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_events", force: true do |t|
    t.integer  "row_number"
    t.string   "event"
    t.integer  "log_event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_events", ["log_event_type_id"], name: "index_log_events_on_log_event_type_id", using: :btree

  create_table "log_files", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "log_file"
    t.integer  "access_type_id"
    t.integer  "user_id"
  end

  create_table "platforms", force: true do |t|
    t.string   "vendor"
    t.string   "name"
    t.string   "version"
    t.integer  "log_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platforms", ["log_file_id"], name: "index_platforms_on_log_file_id", using: :btree

  create_table "pool_statistics", force: true do |t|
    t.string   "stats"
    t.integer  "pool_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pool_statistics", ["pool_id"], name: "index_pool_statistics_on_pool_id", using: :btree

  create_table "pools", force: true do |t|
    t.string   "name"
    t.integer  "log_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pools", ["log_file_id"], name: "index_pools_on_log_file_id", using: :btree

  create_table "runtime_statistics", force: true do |t|
    t.string   "stats"
    t.integer  "log_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "runtime_statistics", ["log_file_id"], name: "index_runtime_statistics_on_log_file_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "avatar_url"
    t.boolean  "is_admin",               default: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
