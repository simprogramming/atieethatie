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

ActiveRecord::Schema[7.0].define(version: 2023_11_21_212143) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "addresses", force: :cascade do |t|
    t.string "address_type"
    t.string "first_name"
    t.string "last_name"
    t.string "address_line"
    t.string "company"
    t.string "apartment"
    t.string "city"
    t.string "province"
    t.string "postal_code"
    t.string "country"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_addresses_on_order_id"
  end

  create_table "catalog_item_variations", force: :cascade do |t|
    t.string "name_fr"
    t.string "name_en"
    t.bigint "catalog_item_id", null: false
    t.integer "inventory", default: 0
    t.float "price"
    t.string "square_id"
    t.bigint "version"
    t.string "color"
    t.string "size"
    t.string "sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "available", default: false
    t.index ["catalog_item_id"], name: "index_catalog_item_variations_on_catalog_item_id"
  end

  create_table "catalog_items", force: :cascade do |t|
    t.string "name_fr"
    t.string "name_en"
    t.bigint "category_id", null: false
    t.string "square_id"
    t.bigint "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "fragrance_id", null: false
    t.index ["category_id"], name: "index_catalog_items_on_category_id"
    t.index ["fragrance_id"], name: "index_catalog_items_on_fragrance_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name_fr"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "square_id"
    t.bigint "version"
  end

  create_table "fragrance_profiles", force: :cascade do |t|
    t.string "name_en"
    t.string "name_fr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fragrances", force: :cascade do |t|
    t.string "name_en"
    t.string "name_fr"
    t.bigint "fragrance_profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fragrance_profile_id"], name: "index_fragrances_on_fragrance_profile_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "image_url"
    t.string "square_id"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "catalog_item_variation_id", null: false
    t.bigint "order_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_item_variation_id"], name: "index_order_items_on_catalog_item_variation_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "session_id"
    t.datetime "paid_at"
    t.integer "version"
    t.string "square_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "net_amount_due_money"
    t.string "payment_id"
    t.string "receipt_number"
    t.string "receipt_url"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "orders"
  add_foreign_key "catalog_item_variations", "catalog_items"
  add_foreign_key "catalog_items", "categories"
  add_foreign_key "catalog_items", "fragrances"
  add_foreign_key "fragrances", "fragrance_profiles"
  add_foreign_key "order_items", "catalog_item_variations"
  add_foreign_key "order_items", "orders"
end
