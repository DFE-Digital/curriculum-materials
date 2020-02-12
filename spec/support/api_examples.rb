def example_ccp(id = 1); end

def example_ccps(quantity)
  1.upto(quantity).map { |i| example_ccp(i) }
end

def example_unit(id = 1); end

def example_units(quantity)
  1.upto(quantity).map { |i| example_unit(i) }
end

def example_lesson(id = 1); end

def example_lessons(quantity)
  1.upto(quantity).map { |i| example_lesson(i) }
end

def example_errors
  ["Name can't be blank"]
end
