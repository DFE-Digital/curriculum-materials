# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_12_161137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_choices", force: :cascade do |t|
    t.integer "activity_number"
    t.string "activity_slug"
    t.string "lesson_slug"
    t.string "unit_slug"
    t.string "complete_curriculum_programme_slug"
    t.bigint "teacher_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_number", "lesson_slug", "unit_slug", "complete_curriculum_programme_slug"], name: "activity_choices_slug_index", unique: true
    t.index ["teacher_id"], name: "index_activity_choices_on_teacher_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.uuid "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_teachers_on_token", unique: true
  end

  add_foreign_key "activity_choices", "teachers"
end
