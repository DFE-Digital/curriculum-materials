module Teachers
  class UnitsController < BaseController
    def show
      @unit = Unit
        .eager_load(:lessons, complete_curriculum_programme: :units)
        .merge(Lesson.ordered_by_position)
        .find(params[:id])

      # FIXME this is only required while we're in MVP and preventing
      #       users from navigating to empty units.
      @siblings = @unit
        .complete_curriculum_programme
        .units
        .ordered_by_position
        .includes(:lessons)
    end
  end
end
