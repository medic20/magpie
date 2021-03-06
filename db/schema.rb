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

ActiveRecord::Schema.define(version: 20161212215158) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string   "tag"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "taggings_count", default: 0,     null: false
    t.boolean  "reserved",       default: false
    t.index ["tag"], name: "index_hashtags_on_tag", unique: true
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "output"
    t.text     "resultfiles"
    t.string   "directory"
    t.text     "arguments"
    t.string   "highlight",   default: "neutral", null: false
    t.string   "docker_id"
    t.index ["project_id"], name: "index_jobs_on_project_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "microposts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "picture"
    t.string   "mentions"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "models", force: :cascade do |t|
    t.string   "name"
    t.string   "path"
    t.text     "mainscript"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "description"
    t.text     "help"
    t.integer  "user_id"
    t.string   "source"
    t.string   "doi"
    t.string   "citation"
    t.string   "category",    default: "Uncategorized"
    t.binary   "logo"
    t.index ["user_id"], name: "index_models_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "model_id"
    t.boolean  "public"
    t.string   "revision"
    t.index ["model_id"], name: "index_projects_on_model_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "rights", force: :cascade do |t|
    t.boolean  "user_delete",     default: false
    t.boolean  "user_index",      default: false
    t.boolean  "projects_delete", default: false
    t.boolean  "model_add",       default: false
    t.boolean  "model_delete",    default: false
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "hashtag_id"
    t.integer  "micropost_id"
    t.integer  "project_id"
    t.integer  "model_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["hashtag_id"], name: "index_taggings_on_hashtag_id"
    t.index ["micropost_id"], name: "index_taggings_on_micropost_id"
    t.index ["model_id"], name: "index_taggings_on_model_id"
    t.index ["project_id"], name: "index_taggings_on_project_id"
    t.index ["user_id"], name: "index_taggings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "guest",             default: false
    t.boolean  "bot",               default: false
    t.string   "identity"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["identity"], name: "index_users_on_identity", unique: true
  end

end
