require_relative 'seeds/teaching_methods'
require_relative 'seeds/loader'

if ENV['KNOWN_TEACHER_UUID'].present?
  Teacher.find_or_create_by! token: ENV['KNOWN_TEACHER_UUID']
end
