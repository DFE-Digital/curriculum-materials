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

ActiveRecord::Schema.define(version: 2020_02_11_134535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "lesson_part_id", null: false
    t.text "overview"
    t.integer "duration", null: false
    t.string "extra_requirements", limit: 32, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lesson_part_id"], name: "index_activities_on_lesson_part_id"
  end

  create_table "activity_teaching_methods", force: :cascade do |t|
    t.integer "teaching_method_id", null: false
    t.integer "activity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_teaching_methods_on_activity_id"
    t.index ["teaching_method_id", "activity_id"], name: "index_activity_teaching_methods_teaching_method_id_activity_id", unique: true
    t.bigint "lesson_id", null: false
    t.string "name", limit: 256, null: false
    t.string "slug", limit: 256, null: false
    t.text "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lesson_id", "slug"], name: "index_activities_on_lesson_id_and_slug", unique: true
    t.index ["lesson_id"], name: "index_activities_on_lesson_id"
  end

  create_table "complete_curriculum_programmes", force: :cascade do |t|
    t.string "name", limit: 256, null: false
    t.string "overview", limit: 1024, null: false
    t.text "benefits", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug", limit: 256, null: false
    t.index ["name"], name: "index_complete_curriculum_programmes_on_name"
    t.index ["slug"], name: "index_complete_curriculum_programmes_on_slug", unique: true
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
    t.string "slug", limit: 256, null: false
    t.index ["name"], name: "index_lessons_on_name"
    t.index ["unit_id", "slug"], name: "index_lessons_on_unit_id_and_slug", unique: true
    t.index ["unit_id"], name: "index_lessons_on_unit_id"
  end

  create_table "resources", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.string "name", limit: 256, null: false
    t.string "sha256", limit: 64, null: false
    t.text "taxonomies"
    t.text "uri"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_resources_on_activity_id"
    t.index ["sha256"], name: "index_resources_on_sha256", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.uuid "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_teachers_on_token", unique: true
  end

  create_table "teaching_methods", force: :cascade do |t|
    t.string "name", limit: 32, null: false
    t.text "description"
    t.string "icon", limit: 64
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer "complete_curriculum_programme_id"
    t.string "name", limit: 256, null: false
    t.string "overview", limit: 1024, null: false
    t.text "benefits", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug", limit: 256, null: false
    t.index ["complete_curriculum_programme_id", "slug"], name: "index_units_on_complete_curriculum_programme_id_and_slug", unique: true
    t.index ["complete_curriculum_programme_id"], name: "index_units_on_complete_curriculum_programme_id"
    t.index ["name"], name: "index_units_on_name"
  end

  add_foreign_key "activities", "lesson_parts"
  add_foreign_key "activity_teaching_methods", "activities"
  add_foreign_key "activity_teaching_methods", "teaching_methods"
  add_foreign_key "activities", "lessons"
  add_foreign_key "lessons", "units"
  add_foreign_key "resources", "activities"
  add_foreign_key "units", "complete_curriculum_programmes"
end
