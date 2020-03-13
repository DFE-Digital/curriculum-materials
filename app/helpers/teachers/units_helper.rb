module Teachers
  module UnitsHelper
    def units_breadcrumbs(unit)
      {
        unit.complete_curriculum_programme.title =>
          teachers_complete_curriculum_programme_year_path(unit.complete_curriculum_programme, unit.year)
      }
    end
  end
end
