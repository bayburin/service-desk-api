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

ActiveRecord::Schema.define(version: 2020_08_14_061720) do

  create_table "ahoy_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.json "properties"
    t.timestamp "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.integer "user_tn"
    t.string "user_fio"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.timestamp "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "answer_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "answer_id", null: false
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_attachments_on_answer_id"
  end

  create_table "answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "ticket_id"
    t.text "reason"
    t.text "answer", null: false
    t.text "link"
    t.boolean "is_hidden", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["ticket_id"], name: "index_answers_on_ticket_id"
  end

  create_table "app_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.string "destination"
    t.string "message"
    t.string "info"
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

  create_table "notification_readers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "tn", null: false
    t.bigint "notification_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_notification_readers_on_notification_id"
    t.index ["tn", "notification_id"], name: "index_notification_readers_on_tn_and_notification_id"
    t.index ["user_id"], name: "index_notification_readers_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "event_type"
    t.integer "tn"
    t.json "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_notifications_on_event_type"
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "original_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_id"], name: "index_questions_on_original_id"
  end

  create_table "responsible_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "responseable_type"
    t.bigint "responseable_id"
    t.integer "tn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["responseable_type", "responseable_id"], name: "index_responsible_users_on_responseable_type_and_responseable_id"
    t.index ["tn"], name: "index_responsible_users_on_tn"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "short_description"
    t.text "long_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "template_works", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "app_template_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_template_id"], name: "index_template_works_on_app_template_id"
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
    t.integer "identity"
    t.bigint "service_id", null: false
    t.integer "original_id"
    t.string "name", null: false
    t.integer "ticket_type"
    t.bigint "ticketable_id"
    t.string "ticketable_type"
    t.integer "state", null: false
    t.boolean "is_hidden", default: true, null: false
    t.integer "sla", limit: 2
    t.boolean "to_approve", default: false, null: false
    t.integer "popularity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delta", default: true
    t.index ["identity"], name: "index_tickets_on_identity"
    t.index ["original_id"], name: "index_tickets_on_original_id"
    t.index ["popularity"], name: "index_tickets_on_popularity"
    t.index ["service_id"], name: "index_tickets_on_service_id"
    t.index ["state"], name: "index_tickets_on_state"
    t.index ["ticket_type"], name: "index_tickets_on_ticket_type"
    t.index ["ticketable_type", "ticketable_id"], name: "index_tickets_on_ticketable_type_and_ticketable_id"
  end

  create_table "user_recommendations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.boolean "external", default: false
    t.string "link"
    t.json "query_params"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.integer "tn"
    t.integer "id_tn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_tn"], name: "index_users_on_id_tn", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["tn"], name: "index_users_on_tn", unique: true
  end

  add_foreign_key "answer_attachments", "answers"
  add_foreign_key "answers", "questions"
  add_foreign_key "services", "categories"
  add_foreign_key "template_works", "app_templates"
  add_foreign_key "ticket_tags", "tags"
  add_foreign_key "ticket_tags", "tickets"
  add_foreign_key "tickets", "services"
  add_foreign_key "users", "roles"
end
