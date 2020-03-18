module Suppliers
  class LessonsController < ApplicationController
    layout 'editor'

    def show
      @lesson = Lesson
        .eager_load(unit: :complete_curriculum_programme)
        .find(params[:id])

      @unit = @lesson.unit
      @ccp = @unit.complete_curriculum_programme
    end
  end
end
