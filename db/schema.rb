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

ActiveRecord::Schema.define(version: 2024_02_01_131525) do

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

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "tag"
    t.string "title", null: false
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

  create_table "newsletters", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.string "header"
    t.string "name"
    t.text "body"
    t.datetime "date"
    t.integer "uploads_info_id"
    t.integer "type", default: 0
    t.string "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["date"], name: "index_newsletters_by_dates", unique: true
    t.index ["subscription_id"], name: "index_newsletters_on_subscription_id"
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

  create_table "subscriptions", force: :cascade do |t|
    t.string "title"
    t.jsonb "uploads_ratings"
    t.jsonb "newsletters_ratings"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.bigint "topic_id"
    t.integer "subs_rate", default: 0
    t.integer "subs_rating", default: 0
    t.json "subs_ratings_infos"
    t.index ["topic_id"], name: "index_subscriptions_on_topic_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "tag"
    t.integer "category_id"
    t.integer "topic_id"
    t.index ["category_id"], name: "index_teams_on_category_id"
  end

  create_table "topic_digests", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.string "list_of_5"
    t.json "full_list"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_id"], name: "index_topic_digests_on_topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title", null: false
    t.string "tag"
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_topics_on_category_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "downloads_count", default: 0
    t.string "status", default: "public"
    t.string "ahoy_visit_id"
    t.integer "rating", default: 0
    t.string "category", default: "", null: false
    t.string "topic", default: ""
    t.bigint "topic_id"
    t.index ["topic_id"], name: "index_uploads_on_topic_id"
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
    t.string "name", null: false
    t.text "description"
    t.decimal "duration"
    t.string "provider"
    t.integer "rating", default: 0
    t.integer "upl_count", default: 0
    t.integer "down_count", default: 0
    t.string "log_tag"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer "subscription_ids", default: [], array: true
    t.string "phone_number"
    t.string "roles", array: true
    t.integer "team_id"
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
  add_foreign_key "newsletters", "subscriptions"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "subscriptions", "topics"
  add_foreign_key "topic_digests", "topics"
  add_foreign_key "topics", "categories"
  add_foreign_key "upload_attachments", "uploads"
  add_foreign_key "uploads", "users"
  add_foreign_key "uploads_info_attacments", "uploads_infos"
  add_foreign_key "uploads_infos", "uploads"
  add_foreign_key "uploads_infos", "users"
end
