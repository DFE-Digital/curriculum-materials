class UnitsController < ApplicationController
  def show
    @unit = Unit
      .eager_load(:lessons, complete_curriculum_programme: :units)
      .find(params[:id])
  end
end
