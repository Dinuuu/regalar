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

ActiveRecord::Schema.define(version: 20160424015923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
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

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree

  create_table "donations", force: true do |t|
    t.integer  "user_id"
    t.integer  "wish_item_id"
    t.integer  "organization_id"
    t.integer  "quantity"
    t.boolean  "done",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donations", ["organization_id"], name: "index_donations_on_organization_id", using: :btree
  add_index "donations", ["user_id"], name: "index_donations_on_user_id", using: :btree
  add_index "donations", ["wish_item_id"], name: "index_donations_on_wish_item_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gift_item_images", force: true do |t|
    t.string   "file"
    t.integer  "gift_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gift_items", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "quantity"
    t.string   "unit"
    t.text     "description"
    t.boolean  "active",      default: true
    t.string   "used_time"
    t.string   "measures"
    t.string   "weight"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "given"
    t.integer  "visits"
    t.boolean  "eliminated",  default: false
    t.string   "slug"
  end

  add_index "gift_items", ["slug"], name: "index_gift_items_on_slug", unique: true, using: :btree
  add_index "gift_items", ["user_id"], name: "index_gift_items_on_user_id", using: :btree

  create_table "gift_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "gift_item_id"
    t.integer  "organization_id"
    t.integer  "quantity"
    t.boolean  "done",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gift_requests", ["gift_item_id"], name: "index_gift_requests_on_gift_item_id", using: :btree
  add_index "gift_requests", ["organization_id"], name: "index_gift_requests_on_organization_id", using: :btree
  add_index "gift_requests", ["user_id"], name: "index_gift_requests_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", force: true do |t|
    t.integer  "level"
    t.string   "title"
    t.integer  "from"
    t.integer  "to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "locality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "logo"
    t.string   "website"
    t.string   "slug"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "organizations_users", id: false, force: true do |t|
    t.integer "user_id",         null: false
    t.integer "organization_id", null: false
  end

  add_index "organizations_users", ["organization_id", "user_id"], name: "index_organizations_users_on_organization_id_and_user_id", using: :btree
  add_index "organizations_users", ["user_id", "organization_id"], name: "index_organizations_users_on_user_id_and_organization_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
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
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "slug"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "wish_items", force: true do |t|
    t.string   "title"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.integer  "quantity"
    t.string   "priority"
    t.text     "description"
    t.string   "unit"
    t.string   "main_image"
    t.boolean  "active",          default: true
    t.integer  "obtained",        default: 0,     null: false
    t.string   "measures"
    t.string   "weight"
    t.datetime "finish_date"
    t.boolean  "eliminated",      default: false
    t.string   "slug"
  end

  add_index "wish_items", ["organization_id"], name: "index_wish_items_on_organization_id", using: :btree
  add_index "wish_items", ["slug"], name: "index_wish_items_on_slug", unique: true, using: :btree

end
