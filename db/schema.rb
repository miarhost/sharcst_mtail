# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_09_11_163544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "disco_recommendations", force: :cascade do |t|
    t.string "subject_type"
    t.bigint "subject_id"
    t.string "item_type"
    t.bigint "item_id"
    t.string "context"
    t.float "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_type", "item_id"], name: "index_disco_recommendations_on_item_type_and_item_id"
    t.index ["subject_type", "subject_id"], name: "index_disco_recommendations_on_subject_type_and_subject_id"
  end

  create_table "jwt_black_lists", force: :cascade do |t|
    t.string "jti", default: "", null: false
    t.datetime "exp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "upload_attachments", force: :cascade do |t|
    t.bigint "upload_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["upload_id"], name: "index_upload_attachments_on_upload_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "date"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "uploads_info_attacments", force: :cascade do |t|
    t.bigint "uploads_info_id", null: false
    t.index ["uploads_info_id"], name: "index_uploads_info_attacments_on_uploads_info_id"
  end

  create_table "uploads_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "upload_id", null: false
    t.json "streaming_infos"
    t.integer "media_type", default: 0
    t.integer "number_of_seeds", default: 0
    t.string "protocol"
    t.string "name", null: false
    t.text "description"
    t.decimal "duration"
    t.string "provider"
    t.index ["upload_id"], name: "index_uploads_infos_on_upload_id"
    t.index ["user_id"], name: "index_uploads_infos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.inet "current_sign_in_ip"
    t.string "jti", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.integer "upload_id"
    t.integer "user_id", null: false
    t.string "url"
    t.integer "state", default: 0, null: false
    t.string "secret", limit: 50, null: false
    t.text "description"
    t.index ["user_id"], name: "index_webhooks_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "upload_attachments", "uploads"
  add_foreign_key "uploads", "users"
  add_foreign_key "uploads_info_attacments", "uploads_infos"
  add_foreign_key "uploads_infos", "uploads"
  add_foreign_key "uploads_infos", "users"
end
