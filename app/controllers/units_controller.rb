class UnitsController < ApplicationController
  def show
    @unit = Unit.show params[:id]
  end
end
