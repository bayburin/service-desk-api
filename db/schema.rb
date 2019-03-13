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

ActiveRecord::Schema.define(version: 2019_03_12_035839) do

  create_table "auth_center_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.string "token_type"
    t.integer "expires_in"
    t.text "access_token"
    t.text "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "short_description"
    t.integer "popularity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delta", default: true
    t.index ["popularity"], name: "index_categories_on_popularity"
  end

  create_table "oauth_access_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name"
    t.string "short_description"
    t.text "install"
    t.boolean "is_sla", null: false
    t.string "sla"
    t.integer "popularity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delta", default: true
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["popularity"], name: "index_services_on_popularity"
  end

  create_table "solutions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ticket_id"
    t.text "reason"
    t.text "solution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_solutions_on_ticket_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_ticket_tags_on_tag_id"
    t.index ["ticket_id"], name: "index_ticket_tags_on_ticket_id"
  end

  create_table "tickets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "service_id"
    t.string "ticket"
    t.integer "popularity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delta", default: true
    t.index ["popularity"], name: "index_tickets_on_popularity"
    t.index ["service_id"], name: "index_tickets_on_service_id"
  end

end
