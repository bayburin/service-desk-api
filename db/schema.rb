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

ActiveRecord::Schema.define(version: 2019_04_15_083135) do

  create_table "answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.text "reason"
    t.text "answer", null: false
    t.text "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_answers_on_ticket_id"
  end

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
    t.string "name", null: false
    t.text "short_description"
    t.integer "popularity", default: 0
    t.string "icon_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delta", default: true
    t.index ["popularity"], name: "index_categories_on_popularity"
  end

  create_table "impressions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", length: { params: 255 }
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: { message: 255 }
    t.index ["user_id"], name: "index_impressions_on_user_id"
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

  create_table "responsible_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "responseable_type"
    t.bigint "responseable_id"
    t.integer "tn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["responseable_type", "responseable_id"], name: "index_responsible_users_on_responseable_type_and_responseable_id"
    t.index ["tn"], name: "index_responsible_users_on_tn"
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "form_id"
    t.string "name", null: false
    t.text "short_description"
    t.text "install"
    t.boolean "is_hidden", default: true, null: false
    t.boolean "has_common_case", default: false, null: false
    t.integer "popularity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delta", default: true
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["form_id"], name: "index_services_on_form_id"
    t.index ["popularity"], name: "index_services_on_popularity"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_ticket_tags_on_tag_id"
    t.index ["ticket_id"], name: "index_ticket_tags_on_ticket_id"
  end

  create_table "tickets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.string "name", null: false
    t.integer "ticket_type", null: false
    t.boolean "is_hidden", default: true, null: false
    t.string "sla"
    t.boolean "to_approve", default: false, null: false
    t.integer "popularity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delta", default: true
    t.index ["popularity"], name: "index_tickets_on_popularity"
    t.index ["service_id"], name: "index_tickets_on_service_id"
    t.index ["ticket_type"], name: "index_tickets_on_ticket_type"
  end

  add_foreign_key "answers", "tickets"
  add_foreign_key "services", "categories"
  add_foreign_key "ticket_tags", "tags"
  add_foreign_key "ticket_tags", "tickets"
  add_foreign_key "tickets", "services"
end
