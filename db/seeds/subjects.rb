['History', 'Art and Design', 'Geography', 'Maths', 'English'].each do |name|
  Subject.find_or_create_by!(name: name)
end
