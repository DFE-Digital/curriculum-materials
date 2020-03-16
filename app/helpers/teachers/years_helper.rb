module Teachers
  module YearsHelper
    # return a different class depending on whether the
    # unit has any lessons, currently those with lessons
    # will have a green top border and those without grey
    def unit_card_class(unit)
      if unit.lessons.any?
        "card-with-lessons"
      else
        "card-without-lessons"
      end
    end
  end
end
