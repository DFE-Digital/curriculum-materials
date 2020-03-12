# Seeding the application
# =======================
#
# Data must be provided to the application seeds in a format that matches the
# example below. This structure matches the hierarchy within the application that
# mandates:
#
# * a complete curriculum program contains units,
# * a units contains lessons,
# * a lesson contains lesson parts,
# * a lesson part contains activities,
# * activities may contain a single slide deck and multiple teacher
#   and pupil resources
#
# For consistency, this structure also requires that the descendents of a node
# in the hierarchy are placed in a directory that matches its name. For
# example, the CCP `the-norman-invasion.yml` has a corresponding
# `the-norman-invasion` directory containing its units.
#
# Here's a full example of an example CCP with one unit, one lesson, five parts
# and eight activities; one with resources:
#
# db/seeds
# └── data
#     └── history
#         ├── the-norman-invasion.yml                                   <--- CCP
#         └── the-norman-invasion
#             ├── the-battle-of-hastings.yml                            <--- Unit
#             └── the-battle-of-hastings
#                 ├── prelude-to-the-battle.yml                         <--- Lesson
#                 └── prelude-to-the-battle
#                     ├── 1                                             <--- Lesson part
#                     │   ├── keyword-matching.yml                      <--- Activity
#                     │   ├── keyword-matching
#                     │   │   ├── pupil
#                     │   │   │   ├── normans.odt                       <--- Pupil resource
#                     │   │   │   ├── normans.preview.pdf               <--- Preview of the pupil resource
#                     │   │   │   └── the-house-of-normandy.pdf
#                     │   │   │   └── the-house-of-normandy.preview.pdf
#                     │   │   ├── slides.odp                            <--- Activity slide deck
#                     │   │   ├── slides.preview.png                    <--- Preview of the slide deck
#                     │   │   └── teacher
#                     │   │       └── norman-conquest.gif               <--- Teacher resource
#                     │   │       └── norman-conquest.preview.gif       <--- Preview of the teacher resource
#                     │   └── ordering-the-battle-events.yml
#                     ├── 2
#                     │   ├── the-story-of-the-battle.yml
#                     │   └── why-did-william-win-the-battle.yml
#                     ├── 3
#                     │   ├── comparing-example-paragraphs.yml
#                     │   └── students-write-their-own-paragraphs.yml
#                     ├── 4
#                     │   └── students-score-their-partners-work.yml
#                     └── 5
#                         └── student-reads-their-paragraph-out.yml
#
# The seeding process can be run in one of two modes; via the API or via the models. If
# an environment variable 'SEED_API_URL' is present it will be run in API-mode, otherwise
# model mode.
require 'faraday'

require_relative 'seeders/base_seeder'
require_relative 'seeders/ccp_seeder'
require_relative 'seeders/unit_seeder'
require_relative 'seeders/lesson_seeder'
require_relative 'seeders/lesson_part_seeder'
require_relative 'seeders/activity_seeder'

def log_progress(msg, indent = 0)
  puts((" " * indent) + msg)
end

def extract_attributes(file, key, symbolize_keys = true)
  attributes = YAML.load_file(file)[key]

  symbolize_keys ? attributes.symbolize_keys : attributes
end

def descendents(origin, matcher = "*.yml")
  Dir.glob(File.join(File.dirname(origin), File.basename(origin, ".yml"), matcher))
end

unless Rails.env.test?
  # First loop through the sample CCPs which can be found in db/seeds/data/{subject}
  Dir.glob(Rails.root.join("db", "seeds", "data", "*", "*.yml")).each do |ccp_file|
    subject = extract_attributes(ccp_file, 'subject', false)

    Seeders::CCPSeeder.new(**extract_attributes(ccp_file, 'ccp').merge(subject: subject)).tap do |ccp|
      log_progress("Saving CCP: #{ccp.name}")
      ccp.save!

      # Second, units
      descendents(ccp_file).each do |unit_file|
        Seeders::UnitSeeder.new(ccp, **extract_attributes(unit_file, 'unit')).tap do |unit|
          log_progress("Saving unit: #{unit.name}", 1)
          unit.save!

          # Third, lessons
          descendents(unit_file).each do |lesson_file|
            Seeders::LessonSeeder.new(ccp, unit, **extract_attributes(lesson_file, 'lesson')).tap do |lesson|
              log_progress("Saving lesson: #{lesson.name}", 2)
              lesson.save!

              # Fourth, lesson parts
              # Note, lesson parts do not have an associated YAML file, instead their only attribute,
              # position, is taken from the directory's name. It must be an integer
              descendents(lesson_file, "*").each do |lesson_part_directory|
                position = Integer(File.basename(lesson_part_directory))

                Seeders::LessonPartSeeder.new(ccp, unit, lesson, position: position).tap do |lesson_part|
                  log_progress("Saving lesson part: #{lesson_part.position}", 3)
                  lesson_part.save!

                  # Fifth, activities
                  descendents(lesson_part_directory).each do |activity_file|
                    teaching_methods = extract_attributes(activity_file, 'teaching_methods', false)

                    Seeders::ActivitySeeder.new(ccp, unit, lesson, lesson_part, **extract_attributes(activity_file, 'activity').merge(teaching_methods: teaching_methods)).tap do |activity|
                      log_progress("Saving activity: #{activity.name}", 4)

                      activity.save!

                      # slide deck
                      descendents(activity_file, '*.odp').each do |slide_deck_path|
                        log_progress("Attaching slide deck", 5)
                        activity.attach_slide_deck(slide_deck_path)
                      end

                      # teacher resources
                      descendents(activity_file, "teacher/*").each do |attachment|
                        log_progress("Attaching teacher resource: #{File.basename(attachment)}", 5)
                        activity.attach_teacher_resource(attachment)
                      end

                      # pupil resources
                      descendents(activity_file, "pupil/*").each do |attachment|
                        log_progress("Attaching pupil resource: #{File.basename(attachment)}", 5)
                        activity.attach_pupil_resource(attachment)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
