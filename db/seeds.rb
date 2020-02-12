if ENV['KNOWN_TEACHER_UUID'].present?
  Teacher.find_or_create_by! token: ENV['KNOWN_TEACHER_UUID']
else
  uuid = SecureRandom.uuid
  Teacher.find_or_create_by! token: uuid
  puts "The login link is http://localhost:3000/teachers/session/#{uuid}"
end
