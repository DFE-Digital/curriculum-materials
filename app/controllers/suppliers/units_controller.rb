module Suppliers
  class UnitsController < ApplicationController
    layout 'editor'

    def show
      @unit = Unit
        .eager_load(:complete_curriculum_programme)
        .find(params[:id])

      @ccp = @unit.complete_curriculum_programme
    end
  end
end
