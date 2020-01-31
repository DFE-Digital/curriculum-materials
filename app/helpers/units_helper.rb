module UnitsHelper
  def units_breadcrumbs(unit)
    {
      unit.complete_curriculum_programme.name =>
        complete_curriculum_programme_path(unit.complete_curriculum_programme)
    }
  end
end
