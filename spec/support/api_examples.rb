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

def example_errors
  ["Name can't be blank"]
end
