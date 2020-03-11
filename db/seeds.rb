require_relative 'seeds/teaching_methods'
require_relative 'seeds/subjects'
require_relative 'seeds/seeder'

if ENV['KNOWN_TEACHER_UUID'].present?
  Teacher.find_or_create_by! token: ENV['KNOWN_TEACHER_UUID']
end
