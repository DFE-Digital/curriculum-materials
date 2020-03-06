def example_ccp(id = 1)
  FactoryBot.attributes_for(:ccp).merge(id: id)
end

def example_ccps(quantity)
  1.upto(quantity).map { |i| example_ccp(i) }
end

def example_unit(id = 1)
  FactoryBot.attributes_for(:unit).merge(id: id)
end

def example_units(quantity)
  1.upto(quantity).map { |i| example_unit(i) }
end

def example_lesson(id = 1)
  FactoryBot.attributes_for(:lesson).merge(id: id)
end

def example_lessons(quantity)
  1.upto(quantity).map { |i| example_lesson(i) }
end

def example_lesson_part(id = 1)
  FactoryBot.attributes_for(:lesson_part).merge(id: id)
end

def example_lesson_parts(quantity)
  1.upto(quantity).map { |i| example_lesson_part(i) }
end

def example_activity(id = 1)
  FactoryBot.attributes_for(:activity).merge(id: id)
end

def example_activities(quantity)
  1.upto(quantity).map { |i| example_activity(i) }
end

def example_teaching_method(id = 1)
  FactoryBot.attributes_for(:teaching_method).merge(id: id)
end

def example_teaching_methods(quantity)
  1.upto(quantity).map { |i| example_teaching_method(i) }
end

def example_subject(id = 1)
  FactoryBot.attributes_for(:subject).merge(id: id)
end

def example_subjects(quantity)
  1.upto(quantity).map { |i| example_subject(i) }
end

def example_errors
  ["Name can't be blank"]
end
