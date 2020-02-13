require_relative 'seeds/geography'
require_relative 'seeds/history'

if ENV['KNOWN_TEACHER_UUID'].present?
  Teacher.find_or_create_by! token: ENV['KNOWN_TEACHER_UUID']
end
