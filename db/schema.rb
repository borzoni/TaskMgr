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

ActiveRecord::Schema.define(version: 20160813165954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string   "attach_file"
    t.integer  "task_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["task_id"], name: "index_attachments_on_task_id", using: :btree
  end

  create_table "auth_tokens", force: :cascade do |t|
    t.integer  "authenticatable_id"
    t.string   "authenticatable_type"
    t.string   "secret_id"
    t.string   "hashed_secret"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "token_type",           default: 0
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable_id_type_idx", using: :btree
    t.index ["secret_id"], name: "index_auth_tokens_on_secret_id", unique: true, using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "role",            default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "activation",      default: 0
    t.datetime "activated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
