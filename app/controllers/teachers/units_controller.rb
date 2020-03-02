module Teachers
  class UnitsController < BaseController
    def show
      @unit = Unit
        .eager_load(:lessons, complete_curriculum_programme: :units)
        .merge(Lesson.ordered_by_position)
        .find(params[:id])
    end
  end
end
