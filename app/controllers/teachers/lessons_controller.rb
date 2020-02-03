module Teachers
  class LessonsController < BaseController
    def show
      @lesson = Lesson.find(params[:id])
    end
  end
end
