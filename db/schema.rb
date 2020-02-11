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

ActiveRecord::Schema.define(version: 2020_02_07_163414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "complete_curriculum_programmes", force: :cascade do |t|
    t.string "name", limit: 256, null: false
    t.string "overview", limit: 1024, null: false
    t.text "benefits", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_complete_curriculum_programmes_on_name"
  end

  create_table "lesson_parts", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.integer "position", null: false
    t.index ["lesson_id"], name: "index_lesson_parts_on_lesson_id"
    t.index ["position", "lesson_id"], name: "index_lesson_parts_on_position_and_lesson_id", unique: true
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "unit_id", null: false
    t.string "name", limit: 256
    t.text "summary"
    t.integer "position"
    t.text "core_knowledge"
    t.string "vocabulary", array: true
    t.string "misconceptions", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.hstore "previous_knowledge"
    t.index ["name"], name: "index_lessons_on_name"
    t.index ["unit_id"], name: "index_lessons_on_unit_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.uuid "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_teachers_on_token", unique: true
  end

  create_table "units", force: :cascade do |t|
    t.integer "complete_curriculum_programme_id"
    t.string "name", limit: 256, null: false
    t.string "overview", limit: 1024, null: false
    t.text "benefits", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["complete_curriculum_programme_id"], name: "index_units_on_complete_curriculum_programme_id"
    t.index ["name"], name: "index_units_on_name"
  end

  add_foreign_key "lessons", "units"
  add_foreign_key "units", "complete_curriculum_programmes"
end
