module Teachers
  module UnitsHelper
    def units_breadcrumbs(unit)
      {
        unit.complete_curriculum_programme.name =>
          teachers_complete_curriculum_programme_path(unit.complete_curriculum_programme)
      }
    end
  end
end
