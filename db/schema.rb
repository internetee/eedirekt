# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_05_093702) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "status_enum", ["issued", "paid", "canceled", "failed", "overdue"]

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "app_sessions", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "sessionable_type"
    t.bigint "sessionable_id"
    t.string "token_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sessionable_type", "sessionable_id"], name: "index_app_sessions_on_sessionable"
  end

  create_table "contacts", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "email"
    t.string "name"
    t.string "phone"
    t.string "ident"
    t.string "code"
    t.string "authInfo"
    t.integer "role"
    t.string "country_code"
    t.jsonb "information", default: {}
    t.datetime "remote_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
  end

  create_table "dnssec_keys", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.integer "flags"
    t.integer "protocol"
    t.integer "algorithm"
    t.string "public_key"
    t.bigint "domain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_dnssec_keys_on_domain_id"
  end

  create_table "domain_contacts", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.bigint "domain_id"
    t.bigint "contact_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_domain_contacts_on_contact_id"
    t.index ["domain_id"], name: "index_domain_contacts_on_domain_id"
  end

  create_table "domain_prices", force: :cascade do |t|
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "valid_from", default: -> { "now()" }, null: false
    t.datetime "valid_to"
    t.integer "duration"
    t.integer "operation_category", default: 0, null: false
    t.string "zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "name"
    t.string "statuses", default: [], array: true
    t.datetime "remote_created_at"
    t.datetime "remote_updated_at"
    t.datetime "expire_at"
    t.jsonb "information", default: {}
    t.bigint "registrant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
    t.index ["registrant_id"], name: "index_domains_on_registrant_id"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "description", null: false
    t.float "quantity", default: 0.0, null: false
    t.float "unit_price", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.integer "number", null: false
    t.string "description"
    t.string "reference_number"
    t.float "vat_rate"
    t.jsonb "buyer_data", default: {}
    t.bigint "buyer_id"
    t.datetime "issue_date"
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.enum "status", default: "issued", null: false, enum_type: "status_enum"
    t.float "total", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_invoices_on_buyer_id"
  end

  create_table "nameservers", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "hostname"
    t.string "ipv4", default: [], array: true
    t.string "ipv6", default: [], array: true
    t.bigint "domain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_nameservers_on_domain_id"
  end

  create_table "pending_actions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "invoice_id"
    t.jsonb "info", default: {}, null: false
    t.integer "action", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "errors_in_response", default: {}
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.index ["invoice_id"], name: "index_pending_actions_on_invoice_id"
    t.index ["user_id"], name: "index_pending_actions_on_user_id"
  end

  create_table "registrar_users", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "name"
    t.string "code"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "code", null: false
    t.string "value"
    t.string "group", null: false
    t.string "format", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["code"], name: "index_settings_on_code", unique: true
  end

  create_table "super_users", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tlds", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "username"
    t.string "base_url"
    t.string "encrypted_password"
    t.string "encrypted_password_iv"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "phone"
    t.string "ident"
    t.integer "role"
    t.string "country_code"
    t.string "city"
    t.string "street"
    t.string "zip"
    t.string "state"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "domains", "contacts", column: "registrant_id"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "contacts", column: "buyer_id"
  add_foreign_key "pending_actions", "invoices"
  add_foreign_key "pending_actions", "users"
end
