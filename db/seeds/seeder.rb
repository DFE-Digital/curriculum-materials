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

def extract_attributes(file, key)
  YAML.load_file(file)[key].symbolize_keys
end

def descendents(origin, matcher = "*.yml")
  Dir.glob(File.join(File.dirname(origin), File.basename(origin, ".yml"), matcher))
end

unless Rails.env.test?
  # First loop through the sample CCPs which can be found in db/seeds/data/{subject}
  Dir.glob(Rails.root.join("db", "seeds", "data", "*", "*.yml")).each do |ccp_file|
    Seeders::CCPSeeder.new(**extract_attributes(ccp_file, 'ccp')).tap do |ccp|
      log_progress("Saving CCP: #{ccp.name}")
      ccp.save

      # Second, units
      descendents(ccp_file).each do |unit_file|
        Seeders::UnitSeeder.new(ccp, **extract_attributes(unit_file, 'unit')).tap do |unit|
          log_progress("Saving unit: #{unit.name}", 1)
          unit.save

          # Third, lessons
          descendents(unit_file).each do |lesson_file|
            Seeders::LessonSeeder.new(ccp, unit, **extract_attributes(lesson_file, 'lesson')).tap do |lesson|
              log_progress("Saving lesson: #{lesson.name}", 2)
              lesson.save

              # Fourth, lesson parts
              # Note, lesson parts do not have an associated YAML file, instead their only attribute,
              # position, is taken from the directory's name. It must be an integer
              descendents(lesson_file, "*").each do |lesson_part_directory|
                position = File.basename(lesson_part_directory)

                # FIXME check that position looks like an integer

                Seeders::LessonPartSeeder.new(ccp, unit, lesson, position: position).tap do |lesson_part|
                  log_progress("Saving lesson part: #{lesson_part.position}", 3)
                  lesson_part.save

                  # Fifth, activities
                  descendents(lesson_part_directory).each do |activity_file|
                    Seeders::ActivitySeeder.new(ccp, unit, lesson, lesson_part, **extract_attributes(activity_file, 'activity')).tap do |activity|
                      log_progress("Saving activity: #{activity.name}", 4)

                      # TODO add teaching methods
                      activity.save
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
