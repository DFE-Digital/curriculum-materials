class LessonsController < ApplicationController
  def show
    @lesson = Lesson.show params[:id]
  end
end
