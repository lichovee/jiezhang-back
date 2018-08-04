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

ActiveRecord::Schema.define(version: 20180804114724) do

  create_table "asset_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "type"
    t.integer "from"
    t.integer "to"
    t.decimal "amount", precision: 12, scale: 2
    t.decimal "residue", precision: 12, scale: 2
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id", default: 0
    t.string "type", default: "deposit"
    t.integer "lock", default: 0
    t.string "icon_path"
    t.text "remark"
    t.integer "creator_id"
    t.integer "frequent", default: 0
    t.integer "order", default: 0
    t.index ["amount"], name: "index_assets_on_amount"
    t.index ["order"], name: "index_assets_on_order"
    t.index ["parent_id"], name: "index_assets_on_parent_id"
    t.index ["type"], name: "index_assets_on_type"
  end

  create_table "bonus_points_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.integer "type", default: 0
    t.integer "point", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "name"
    t.integer "parent_id", default: 0, null: false
    t.integer "order", default: 0, null: false
    t.string "icon_path"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "lock", default: 0
    t.decimal "budget", precision: 12, scale: 2, default: "0.0"
    t.integer "frequent", default: 0
    t.index ["order"], name: "index_categories_on_order"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["type"], name: "index_categories_on_type"
  end

  create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type", default: 0
  end

  create_table "friend_applies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "source_id"
    t.integer "target_id"
    t.string "remark"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friends", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "target_id"
    t.string "remark"
    t.integer "active", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.integer "from_user_id"
    t.integer "target_id"
    t.integer "target_type"
    t.text "content"
    t.string "content_type", default: "md"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "already_read", default: 0
    t.string "page_url"
  end

  create_table "pre_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "owner_id"
    t.integer "creator_id"
    t.string "name"
    t.decimal "amount", precision: 12, scale: 2
    t.string "state", default: "pending"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", null: false
    t.integer "category_id"
    t.integer "asset_id", null: false
    t.decimal "amount", precision: 12, scale: 2
    t.string "type", null: false
    t.text "description"
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "time"
    t.decimal "residue", precision: 12, scale: 2, default: "0.0"
    t.text "location"
    t.string "nation"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "street"
    t.index ["type"], name: "index_statements_on_type"
    t.index ["user_id", "asset_id"], name: "index_statements_on_user_id_and_asset_id"
    t.index ["user_id", "category_id"], name: "index_statements_on_user_id_and_category_id"
    t.index ["user_id", "type"], name: "index_statements_on_user_id_and_type"
    t.index ["year", "month", "day", "time"], name: "index_statements_on_year_and_month_and_day_and_time"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.integer "theme_id", default: 0
    t.string "openid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "language"
    t.string "city"
    t.string "province"
    t.string "avatar_url", limit: 512
    t.string "country"
    t.string "session_key"
    t.integer "gender"
    t.integer "uid", default: 0, null: false
    t.string "third_session"
    t.string "phone"
    t.decimal "budget", precision: 12, scale: 2, default: "0.0"
    t.string "bg_avatar_url"
    t.integer "bonus_points", default: 0
    t.index ["openid"], name: "index_users_on_openid", unique: true
  end

  create_table "users_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "asset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
