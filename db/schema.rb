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

ActiveRecord::Schema[7.0].define(version: 2022_10_18_022035) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classes", force: :cascade do |t|
    t.string "semester"
    t.string "teacher"
    t.integer "section"
    t.string "course_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.integer "uin"
    t.integer "class_id"
    t.string "email"
    t.string "classification"
    t.string "major"
    t.string "final_grade"
    t.text "notes"
    t.text "tags"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "username", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "classes", "users", column: "teacher", primary_key: "username"
  add_foreign_key "students", "classes"
end
