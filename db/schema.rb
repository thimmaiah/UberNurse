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

ActiveRecord::Schema.define(version: 20170511165319) do

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "hiring_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "start_date"
    t.string   "start_time",   limit: 20
    t.date     "end_date"
    t.integer  "num_of_hours"
    t.float    "rate",         limit: 24
    t.string   "req_type",     limit: 20
    t.integer  "user_id"
    t.integer  "hospital_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "hiring_responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "hiring_request_id"
    t.text     "notes",             limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "hospitals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "address"
    t.string   "street"
    t.string   "locality"
    t.string   "town"
    t.string   "postcode"
    t.float    "base_rate",  limit: 24
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.text     "image_url",  limit: 65535
    t.decimal  "lat",                      precision: 18, scale: 15
    t.decimal  "lng",                      precision: 18, scale: 15
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_hospitals_on_deleted_at", using: :btree
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "staffing_response_id"
    t.integer  "user_id"
    t.integer  "hospital_id"
    t.integer  "paid_by_id"
    t.float    "amount",               limit: 24
    t.text     "notes",                limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "staffing_request_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree
    t.index ["hospital_id"], name: "index_payments_on_hospital_id", using: :btree
    t.index ["staffing_request_id"], name: "index_payments_on_staffing_request_id", using: :btree
    t.index ["staffing_response_id"], name: "index_payments_on_staffing_response_id", using: :btree
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

  create_table "postcodelatlng", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string  "postcode",  limit: 8,                           null: false
    t.decimal "latitude",            precision: 18, scale: 15, null: false
    t.decimal "longitude",           precision: 18, scale: 15, null: false
    t.index ["postcode"], name: "index_postcodelatlng_on_postcode", using: :btree
  end

  create_table "ratings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "staffing_response_id"
    t.integer  "stars"
    t.text     "comments",             limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "created_by_id"
    t.integer  "hospital_id"
    t.index ["staffing_response_id"], name: "index_ratings_on_staffing_response_id", using: :btree
    t.index ["user_id"], name: "index_ratings_on_user_id", using: :btree
  end

  create_table "staffing_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "hospital_id"
    t.integer  "user_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "rate_per_hour",    limit: 24
    t.string   "request_status",   limit: 20
    t.float    "auto_deny_in",     limit: 24
    t.integer  "response_count"
    t.string   "payment_status",   limit: 20
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "start_code",       limit: 10
    t.string   "end_code",         limit: 10
    t.string   "broadcast_status"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_staffing_requests_on_deleted_at", using: :btree
    t.index ["hospital_id"], name: "index_staffing_requests_on_hospital_id", using: :btree
    t.index ["user_id"], name: "index_staffing_requests_on_user_id", using: :btree
  end

  create_table "staffing_responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "staffing_request_id"
    t.integer  "user_id"
    t.string   "start_code",          limit: 10
    t.string   "end_code",            limit: 10
    t.string   "response_status",     limit: 20
    t.boolean  "accepted"
    t.boolean  "rated"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "hospital_id"
    t.string   "payment_status",      limit: 10
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_staffing_responses_on_deleted_at", using: :btree
    t.index ["hospital_id"], name: "index_staffing_responses_on_hospital_id", using: :btree
    t.index ["staffing_request_id"], name: "index_staffing_responses_on_staffing_request_id", using: :btree
    t.index ["user_id"], name: "index_staffing_responses_on_user_id", using: :btree
  end

  create_table "user_docs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "doc_type"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.boolean  "verified"
    t.text     "notes",            limit: 65535
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_docs_on_deleted_at", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider",                                                       default: "email", null: false
    t.string   "uid",                                                            default: "",      null: false
    t.string   "encrypted_password",                                             default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                  default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "role",                   limit: 10
    t.string   "nurse_type",             limit: 20
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at",                                                                       null: false
    t.datetime "updated_at",                                                                       null: false
    t.string   "sex",                    limit: 1
    t.string   "phone",                  limit: 15
    t.text     "address",                limit: 65535
    t.string   "languages"
    t.integer  "pref_commute_distance"
    t.string   "occupation",             limit: 20
    t.string   "speciality",             limit: 50
    t.integer  "experience"
    t.string   "referal_code",           limit: 10
    t.boolean  "accept_terms"
    t.integer  "hospital_id"
    t.boolean  "active"
    t.text     "image_url",              limit: 65535
    t.string   "sort_code",              limit: 6
    t.string   "bank_account",           limit: 8
    t.boolean  "verified"
    t.date     "auto_selected_date"
    t.decimal  "lat",                                  precision: 18, scale: 15
    t.decimal  "lng",                                  precision: 18, scale: 15
    t.string   "postcode",               limit: 10
    t.integer  "total_rating"
    t.integer  "rating_count"
    t.text     "push_token",             limit: 65535
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["hospital_id"], name: "index_users_on_hospital_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end
