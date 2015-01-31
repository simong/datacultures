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

ActiveRecord::Schema.define(version: 20150115105930105930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "reason",                              null: false
    t.integer  "delta",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "canvas_user_id",                      null: false
    t.string   "scoring_item_id",                     null: false
    t.datetime "canvas_updated_at"
    t.text     "body"
    t.boolean  "score"
    t.string   "gallery_id"
    t.boolean  "expired",             default: false
    t.boolean  "assigned_discussion", default: false
  end

  add_index "activities", ["deleted_at"], name: "index_activities_on_deleted_at", using: :btree
  add_index "activities", ["scoring_item_id", "reason"], name: "index_activities_on_scoring_item_id_and_reason", using: :btree

  create_table "assignments", force: true do |t|
    t.string   "name"
    t.integer  "canvas_assignment_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.integer  "canvas_user_id"
    t.integer  "assignment_id"
    t.integer  "submission_id"
    t.string   "author"
    t.string   "content_type"
    t.text     "image_url"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachment_id"
    t.datetime "date"
    t.string   "gallery_id"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.string   "gallery_id",        null: false
    t.integer  "authors_canvas_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "generic_urls", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "canvas_user_id"
    t.string   "gallery_id"
    t.string   "url"
    t.string   "image_url"
    t.datetime "submitted_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_urls", force: true do |t|
    t.string   "site_tag"
    t.string   "site_id"
    t.integer  "canvas_user_id"
    t.integer  "canvas_assignment_id"
    t.string   "author"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gallery_id"
    t.string   "thumbnail_url"
    t.datetime "submitted_at"
  end

  create_table "points_configurations", force: true do |t|
    t.string   "pcid",                             null: false
    t.string   "interaction",                      null: false
    t.integer  "points_associated",                null: false
    t.boolean  "active",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.integer  "canvas_user_id",                              null: false
    t.string   "name",                                        null: false
    t.string   "sortable_name",                               null: false
    t.integer  "sis_user_id",                                 null: false
    t.string   "primary_email"
    t.string   "section",                                     null: false
    t.boolean  "share",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_answered_share_question", default: false
  end

  add_index "students", ["canvas_user_id"], name: "index_students_on_canvas_user_id", unique: true, using: :btree

  create_table "views", force: true do |t|
    t.string   "gallery_id"
    t.integer  "views",      default: 0
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
