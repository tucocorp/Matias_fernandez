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

ActiveRecord::Schema.define(version: 20141128202457) do

  create_table "activities", force: true do |t|
    t.integer  "code"
    t.string   "name"
    t.text     "description"
    t.integer  "status",       default: 0
    t.integer  "duration"
    t.integer  "effort"
    t.integer  "evaluation",   default: 0
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "date_type"
    t.integer  "assigned_id"
    t.integer  "list_id"
    t.integer  "milestone_id"
    t.integer  "meeting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendees", force: true do |t|
    t.integer  "meeting_id"
    t.integer  "user_id"
    t.integer  "status",       default: 0, null: false
    t.string   "token"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "companies", force: true do |t|
    t.string   "initials"
    t.string   "name"
    t.text     "description"
    t.string   "rut"
    t.string   "business_name"
    t.string   "website"
    t.string   "contact_name"
    t.string   "phone_number"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constraints", force: true do |t|
    t.string   "name"
    t.datetime "end_date"
    t.integer  "status",      default: 0
    t.integer  "category_id"
    t.integer  "activity_id"
    t.integer  "assigned_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constraints_issues", id: false, force: true do |t|
    t.integer "constraint_id"
    t.integer "issue_id"
  end

  create_table "issues", force: true do |t|
    t.text     "name"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "list_type"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.integer  "type",               default: 0
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "milestone_id"
    t.integer  "project_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "evaluation_ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", force: true do |t|
    t.text     "name"
    t.date     "end_date"
    t.boolean  "latest",      default: false
    t.integer  "assigned_id"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "permission"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_members", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "status",           default: 0
    t.string   "projectable_type"
    t.integer  "projectable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "release_activities", id: false, force: true do |t|
    t.integer  "released_by"
    t.integer  "release_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "tasks", force: true do |t|
    t.integer  "code"
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "assigned_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "duration"
    t.integer  "meeting_id"
    t.integer  "presenter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_works", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "avatar"
    t.string   "name"
    t.string   "last_name"
    t.string   "address"
    t.integer  "phone_number"
    t.integer  "cell_phone"
    t.string   "position"
    t.date     "date_of_birth"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
