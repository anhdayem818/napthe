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

ActiveRecord::Schema.define(version: 2020_04_29_030959) do

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menh_gia", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "nha_mang_id"
    t.integer "so_tien"
    t.float "phan_tram_chiec_khau"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menh_gias", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "nha_mang_id"
    t.float "phan_tram_chiec_khau"
    t.float "so_tien"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nha_mang_id"], name: "index_menh_gias_on_nha_mang_id"
  end

  create_table "nha_mangs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ten"
    t.float "phan_tram_chiec_khau"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "number"
    t.integer "loai_thanh_toan"
    t.integer "so_tien"
    t.text "note"
    t.text "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

  create_table "transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.integer "status"
    t.string "menh_gia"
    t.text "note"
    t.text "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.float "xu", default: 0.0
    t.integer "ref_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["ref_id"], name: "index_users_on_ref_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
