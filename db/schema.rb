# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151030214459) do

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
  end

  create_table "passwords", force: :cascade do |t|
    t.integer "user_id"
    t.string  "password"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "body",        limit: 150
    t.integer  "user_id"
    t.datetime "date_posted"
    t.integer  "favorites"
  end

  create_table "profiles", force: :cascade do |t|
    t.string  "country"
    t.string  "picture_path"
    t.string  "post_picture_path"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "username"
    t.datetime "join_date"
  end

end
