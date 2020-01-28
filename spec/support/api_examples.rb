def example_ccp(id = 1)
  FactoryBot.attributes_for(:ccp, :randomised).merge(id: id)
end

def example_ccps(quantity)
  1.upto(quantity).map { |i| example_ccp(i) }
end

def example_unit(id = 1)
  FactoryBot.attributes_for(:unit, :randomised).merge(id: id)
end

def example_units(quantity)
  1.upto(quantity).map { |i| example_unit(i) }
end

def example_lesson(id = 1)
  FactoryBot.attributes_for(:lesson, :randomised).merge(id: id)
end

def example_lessons(quantity)
  1.upto(quantity).map { |i| example_lesson(i) }
end